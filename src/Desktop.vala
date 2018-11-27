public class Tootle.Desktop {

    // Open URI in the user's default application associated with it
    public static void open_uri (string uri) {
        try {
            Gtk.show_uri (null, uri, Gdk.CURRENT_TIME);
        }
        catch (GLib.Error e){
            warning ("Can't open %s: %s", uri, e.message);
            app.error (_("Error"), e.message);
        }
    }

    // Copy a string to the clipboard
    public static void copy (string str) {
        var display = window.get_display ();
        var clipboard = Gtk.Clipboard.get_for_display (display, Gdk.SELECTION_CLIPBOARD);
        clipboard.set_text (RichLabel.restore_entities (str), -1);
    }

    // Download a file from the web to a user's configured Downloads folder
    public static void download_file (string url) {
        debug ("Downloading file: %s", url);
        
        var i = url.last_index_of ("/");
        var name = url.substring (i + 1, url.length - i - 1);
        if (name == null)
            name = "unknown";
        
        var dir_path = "%s/".printf (GLib.Environment.get_user_special_dir (UserDirectory.DOWNLOAD));
        var file_path = "%s/%s".printf (dir_path, name);
        
        var msg = new Soup.Message("GET", url);
        msg.finished.connect(() => {
            try {
                var dir = File.new_for_path (dir_path);
                if (!dir.query_exists ())
                    dir.make_directory ();

                var file = File.new_for_path (file_path);
                if (!file.query_exists ()) {
                    var data = msg.response_body.data;
                    FileOutputStream stream = file.create (FileCreateFlags.PRIVATE);
                    stream.write (data);
                }
                app.toast (_("Media downloaded"));
            } catch (Error e) {
                app.toast (e.message);
                warning ("Error: %s\n", e.message);
            }
        });
        network.queue (msg);
    }
    
    public static string fallback_icon (string normal, string fallback) {
        var theme = Gtk.IconTheme.get_default ();
        return theme.has_icon (normal) ? normal : fallback;
    }
    
}
