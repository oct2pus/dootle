using Gtk;
using GLib;
using Gdk;

// Partial reimplimentation of Granite.Widgets.Avatar

public class Tootle.AccountAvatar : Gtk.EventBox {

    private const string DEFAULT_ICON = "avatar-default-symbolic";
    private const int DEFAULT_SIZE = 16;

    private bool? is_default = null;
    private string? orig_filename = null;

    public Gtk.Image avatar {set; get;}
    public Gdk.Pixbuf? pixbuf {get; set;}

    public AccountAvatar () {
        // And yet nobody came..
    }

    public AccountAvatar.from_file (string filepath, int pixel_size) {
        avatar = load_image (filepath, pixel_size);
        orig_filename = filepath;
    }

    public AccountAvatar.with_default_icon (int pixel_size) {
        Gtk.IconSize icon_size = int_to_icon_size(pixel_size);
        avatar = new Gtk.Image.from_icon_name(DEFAULT_ICON, icon_size);
        is_default = true;
    }

    public AccountAvatar.from_pixbuf (Gdk.Pixbuf pixbuf) {
        avatar =  new Gtk.Image.from_pixbuf(pixbuf);
        is_default = false;
    }

    construct {
        valign = Gtk.Align.CENTER;
        halign = Gtk.Align.CENTER;
    }

    public void show_default (int pixel_size) {
        Gtk.IconSize icon_size = int_to_icon_size (pixel_size);
        avatar.set_from_icon_name(DEFAULT_ICON, icon_size);
        is_default = true;
    }

    private Gtk.Image load_image (string filepath, int pixel_size) {

        Gtk.Image image = null;

        try {
            var size = pixel_size * get_scale_factor ();
            pixbuf = new Gdk.Pixbuf.from_file_at_size (filepath, size, size);
            image = new Gtk.Image.from_pixbuf(pixbuf);
            is_default = false;
        } catch (Error e) {
            Gtk.IconSize iconSize = int_to_icon_size(pixel_size);
            image = new Gtk.Image.from_icon_name(DEFAULT_ICON, iconSize);
            is_default = true;
        }


        return image;
    }

    // fiddle with this and these exact numbers later
    private Gtk.IconSize int_to_icon_size(int input) {
        if (input <= 16) {
          return Gtk.IconSize.SMALL_TOOLBAR; // this should be the same as menu and button, yell very loudly if it isn't
        } else if (input <= 24) {
            return Gtk.IconSize.LARGE_TOOLBAR;
        } else if (input <= 32) {
            return Gtk.IconSize.DND;
        } else if (input > 32) {
            return Gtk.IconSize.DIALOG;
        } else {
            return Gtk.IconSize.INVALID;    // You should never reach this
        }
    }
}
