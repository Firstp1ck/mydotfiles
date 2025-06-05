# TODO Destroys my Config

import commentjson as json
import os
import customtkinter as ctk
from tkinter import messagebox
import subprocess
import time
import psutil

WAYBAR_CONFIG_PATH = os.path.expanduser("~/.config/waybar/config.jsonc")

def load_modules():
    with open(WAYBAR_CONFIG_PATH, "r") as f:
        config = json.load(f)
    modules = []
    module_positions = {}  # {module: (section, index)}
    for section in ["modules-left", "modules-center", "modules-right"]:
        for idx, mod in enumerate(config.get(section, [])):
            modules.append(mod)
            module_positions[mod] = (section, idx)
    # Add disabled modules
    for idx, mod in enumerate(config.get("modules-disabled", [])):
        if mod not in modules:
            modules.append(mod)
            module_positions[mod] = ("modules-disabled", idx)
    # Add custom modules not in any section
    for key in config:
        if key.startswith("custom/") and key not in modules:
            modules.append(key)
            module_positions[key] = ("modules-right", len(config.get("modules-right", [])))
    return modules, config, module_positions

def save_modules(selected_modules, config, module_positions):
    # Ensure modules-disabled exists
    if "modules-disabled" not in config:
        config["modules-disabled"] = []
    enabled_sections = ["modules-left", "modules-center", "modules-right"]

    # Prepare new lists for each section, preserving order
    new_sections = {sec: [] for sec in enabled_sections}
    new_disabled = []

    # Sort modules by their original position for each section
    sorted_modules = sorted(module_positions.items(), key=lambda x: (x[1][0], x[1][1]))

    for mod, (section, idx) in sorted_modules:
        if mod in selected_modules:
            # Place in its original section if enabled
            if section in enabled_sections:
                new_sections[section].append(mod)
            else:
                # If it was only in disabled, put in modules-right (or pick a default)
                new_sections["modules-right"].append(mod)
        else:
            new_disabled.append(mod)

    # Update config sections
    for sec in enabled_sections:
        config[sec] = new_sections[sec]
    config["modules-disabled"] = new_disabled

    with open(WAYBAR_CONFIG_PATH, "w") as f:
        json.dump(config, f, indent=2)

def main():
    modules, config, module_positions = load_modules()
    ctk.set_appearance_mode("System")
    ctk.set_default_color_theme("blue")
    root = ctk.CTk()
    root.title("Waybar Module Selector")
    frame = ctk.CTkFrame(root)
    frame.pack(padx=20, pady=20, fill="both", expand=True)
    vars = {}
    # Show all modules, checked if enabled, unchecked if disabled
    enabled_sections = ["modules-left", "modules-center", "modules-right"]
    enabled_modules = []
    for sec in enabled_sections:
        enabled_modules += config.get(sec, [])
    for mod in modules:
        var = ctk.BooleanVar(value=mod in enabled_modules)
        chk = ctk.CTkCheckBox(frame, text=mod, variable=var)
        chk.pack(anchor="w", pady=2)
        vars[mod] = var

    def on_save():
        selected = [mod for mod, var in vars.items() if var.get()]
        save_modules(selected, config, module_positions)
        env = os.environ.copy()
        print("WAYLAND_DISPLAY in env:", env.get("WAYLAND_DISPLAY"))  # Debug
        subprocess.run("pkill waybar", shell=True)
        time.sleep(1)
        subprocess.Popen("waybar", shell=True, env=env)
        messagebox.showinfo("Saved", "Waybar config updated and Waybar restarted!")

    btn = ctk.CTkButton(frame, text="Save and Restart Waybar", command=on_save)
    btn.pack(pady=10)
    root.mainloop()

if __name__ == "__main__":
    main()