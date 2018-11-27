using Gtk;
using GLib;
using Granite;

namespace Tootle{

    public static Application app;
    public static MainWindow? window;
    public static Window window_dummy;
    
    public static Settings settings;
    public static Accounts accounts;
    public static Network network;
    public static ImageCache image_cache;

    public class Application : Gtk.Application {
    
        public abstract signal void refresh ();
        public abstract signal void toast (string title);
        public abstract signal void error (string title, string text);
    
        construct {
            application_id = "com.github.oct2pus.dootle";
            flags = ApplicationFlags.FLAGS_NONE;
//            program_name = "Dootle";
//            build_version = "1";
        }

        public static int main (string[] args) {
            Gtk.init (ref args);
            app = new Application ();
            return app.run (args);
        }
        
        protected override void startup () {
            base.startup ();
//            Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.INFO;
            
            settings = new Settings ();
            accounts = new Accounts ();
            network = new Network ();
            image_cache = new ImageCache ();
            accounts.init ();
                                    
            app.error.connect (app.on_error);
            
            window_dummy = new Window ();
            add_window (window_dummy);
        }
        
        protected override void activate () {
            if (window != null)
                return;
            
            debug ("Creating new window");
            if (accounts.is_empty ())
                NewAccountDialog.open ();
            else {
                window = new MainWindow (this);
                window.present ();
            }
        }
        
        protected void on_error (string title, string msg){
            var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (title, msg, "dialog-warning");
            message_dialog.transient_for = window;
            message_dialog.run ();
            message_dialog.destroy ();
        }
    
    }

}
