using Gtk;
using Tootle;

public class Tootle.SettingsDialog : Gtk.Dialog {

    private static SettingsDialog dialog;

    private SettingsSwitch switch_notifications;
    private SettingsSwitch switch_watcher;
    private SettingsSwitch switch_stream;
    private SettingsSwitch switch_stream_public;
    private Gtk.Grid grid;

    public SettingsDialog () {
        border_width = 6;
        deletable = true;
        resizable = false;
        title = _("Settings");
        transient_for = Tootle.window;
        
        int i = 0;
        grid = new Gtk.Grid ();
        
        switch_watcher = new SettingsSwitch ("always-online");
        switch_notifications = new SettingsSwitch ("notifications");
        switch_notifications.state_set.connect (state => {
            switch_watcher.sensitive = state;
            return false;
        });
        switch_stream = new SettingsSwitch ("live-updates");
        switch_stream_public = new SettingsSwitch ("live-updates-public");
        switch_stream.state_set.connect (state => {
            switch_stream_public.sensitive = state;
            return false;
        });
        
        grid.attach (new SettingsHeader (_("<b>Appearance</b>")), 0, i++, 2, 1);
        grid.attach (new SettingsLabel (_("Dark theme")), 0, i);
        grid.attach (new SettingsSwitch ("dark-theme"), 1, i++);
        
        grid.attach (new SettingsHeader (_("<b>Timelines</b>")), 0, i++, 2, 1);
        grid.attach (new SettingsLabel (_("Real-time updates")), 0, i);
        grid.attach (switch_stream, 1, i++);
        grid.attach (new SettingsLabel (_("Update public timelines")), 0, i);
        grid.attach (switch_stream_public, 1, i++);
        
         grid.attach (new SettingsHeader (_("Caching")), 0, i++, 2, 1);
         grid.attach (new SettingsLabel (_("Use cache:")), 0, i);
         grid.attach (new SettingsSwitch ("cache"), 1, i++);
         grid.attach (new SettingsLabel (_("Max cache size (MB):")), 0, i);
         var cache_size = new Gtk.SpinButton.with_range (16, 256, 1);
         settings.schema.bind ("cache-size", cache_size, "value", SettingsBindFlags.DEFAULT);
         grid.attach (cache_size, 1, i++);
        
        grid.attach (new SettingsHeader (_("<b>Notifications</b>")), 0, i++, 2, 1);
        grid.attach (new SettingsLabel (_("Display notifications")), 0, i);
        grid.attach (switch_notifications, 1, i++);
        grid.attach (new SettingsLabel (_("Always receive notifications")), 0, i);
        grid.attach (switch_watcher, 1, i++);
        
        var content = get_content_area () as Gtk.Box;
        content.pack_start (grid, false, false, 0);
        
        show_all ();
    }

    public static void open () {
        if (dialog == null)
            dialog = new SettingsDialog ();
    }

    protected class SettingsHeader : Gtk.Label {
        public SettingsHeader (string text) {
            label = text;
            halign = Gtk.Align.START;
            set_use_markup (true);
            valign = Gtk.Align.CENTER;
            margin_start = 12;
            margin_end = 12;
        }
    }

    protected class SettingsLabel : Gtk.Label {
        public SettingsLabel (string text) {
            label = text;
            halign = Gtk.Align.START;
            valign = Gtk.Align.CENTER;
            margin_start = 12;
            margin_end = 12;
        }
    }

    protected class SettingsSwitch : Gtk.Switch {
        public SettingsSwitch (string setting) {
            halign = Gtk.Align.END;
            valign = Gtk.Align.CENTER;
            margin_bottom = 6;
            Tootle.settings.schema.bind (setting, this, "active", SettingsBindFlags.DEFAULT);
        }
    }

}
