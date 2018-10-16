/*
 *  Copyright (C) 2015-2017 Granite Developers (https://launchpad.net/granite)
 *
 *  This program or library is free software; you can redistribute it
 *  and/or modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 3 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General
 *  Public License along with this library; if not, write to the
 *  Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 *  Boston, MA 02110-1301 USA.
 *
 *  Authored by:
 *  - Felipe Escoto <felescoto95@hotmail.com>,
 *  - Rico Tzschichholz <ricotz@ubuntu.com>
 */

// Some functions are directly lifted from Granite.Widgets.Avatar
// A Single function is directly lifted from Granite.Drawing.Utilities
// This particular file is licenced lGPL v3 because of this.

using Gtk;
using GLib;
using Gdk;

// reimplimentation of Granite.Widgets.Avatar
// TODO: Heavily improve upon this

public class Tootle.AccountAvatar : Gtk.EventBox {

    private const string DEFAULT_ICON = "avatar-default-symbolic";
    private const int DEFAULT_SIZE = 16;
    private const int EXTRA_MARGIN = 4;

    private bool? is_default = null;
    private string? orig_filename = null;
    private int? orig_pixel_size = null;
    private bool draw_theme_background = true;

    public Gtk.Image avatar {set; get;}
    public Gdk.Pixbuf? pixbuf {get; set;}

    public AccountAvatar () {
        // And yet nobody came..
    }

    public AccountAvatar.from_file (string filepath, int pixel_size) {
        avatar = load_image (filepath, pixel_size);
        orig_filename = filepath;
        orig_pixel_size = pixel_size;
    }

    public AccountAvatar.with_default_icon (int pixel_size) {
        Gtk.IconSize icon_size = int_to_icon_size(pixel_size);
        avatar = new Gtk.Image.from_icon_name(DEFAULT_ICON, icon_size);
        is_default = true;
        orig_pixel_size = pixel_size;
    }

    public AccountAvatar.from_pixbuf (Gdk.Pixbuf pixbuf) {
        avatar =  new Gtk.Image.from_pixbuf(pixbuf);
        is_default = false;
    }

    construct {
        valign = Gtk.Align.CENTER;
        halign = Gtk.Align.CENTER;
        visible_window = false;

        notify["pixbuf"].connect (refresh_size_request);
        Gdk.Screen.get_default ().monitors_changed.connect (dpi_change);
    }

    ~AccountAvatar () {
        notify["pixbuf"].disconnect (refresh_size_request);
        Gdk.Screen.get_default ().monitors_changed.disconnect (dpi_change);
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

    private void refresh_size_request () {
        if (pixbuf != null) {
            var scale_factor = get_scale_factor ();
            set_size_request (pixbuf.width / scale_factor + EXTRA_MARGIN * 2,
                pixbuf.height / scale_factor + EXTRA_MARGIN * 2);
            draw_theme_background = true;
        } else {
            set_size_request (0, 0);
        }

        queue_draw ();
    }

    private void dpi_change () {
        if (is_default && orig_pixel_size != null) {
            show_default (orig_pixel_size);
        } else {
            if (orig_filename != null && orig_pixel_size != null) {
                load_image (orig_filename, orig_pixel_size);
            }
        }
    }


    // fiddle with this and these exact numbers later
    private Gtk.IconSize int_to_icon_size(int input) {
        if (input <= 16) {
          return Gtk.IconSize.SMALL_TOOLBAR; // this should be the same as menu
                                             // and button,
                                             // yell very loudly if it isn't
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

    public override bool draw (Cairo.Context cr) {
        if (pixbuf == null) {
            return base.draw (cr);
        }

        unowned Gtk.StyleContext style_context = get_style_context ();
        var width = get_allocated_width () - EXTRA_MARGIN * 2;
        var height = get_allocated_height () - EXTRA_MARGIN * 2;
        var scale_factor = get_scale_factor ();

        if (draw_theme_background) {
            var border_radius = style_context.get_property (
                Gtk.STYLE_PROPERTY_BORDER_RADIUS,
                style_context.get_state ()).get_int ();
            var crop_radius = int.min (width / 2, border_radius * width / 100);

            cairo_rounded_rectangle (cr, EXTRA_MARGIN, EXTRA_MARGIN, width,
                height, crop_radius);
            cr.save ();
            cr.scale (1.0 / scale_factor, 1.0 / scale_factor);
            Gdk.cairo_set_source_pixbuf (cr, pixbuf,
                EXTRA_MARGIN * scale_factor, EXTRA_MARGIN * scale_factor);
            cr.fill_preserve ();
            cr.restore ();
            style_context.render_background (cr, EXTRA_MARGIN, EXTRA_MARGIN,
                width, height);
            style_context.render_frame (cr, EXTRA_MARGIN, EXTRA_MARGIN,
                width, height);

        } else {
            cr.save ();
            cr.scale (1.0 / scale_factor, 1.0 / scale_factor);
            style_context.render_icon (cr, pixbuf, EXTRA_MARGIN, EXTRA_MARGIN);
            cr.restore ();
        }

        return Gdk.EVENT_STOP;
    }

    private static void cairo_rounded_rectangle (Cairo.Context cr, double x,
        double y, double width, double height, double radius) {

            cr.move_to (x + radius, y);
            cr.arc (x + width - radius, y + radius, radius, Math.PI * 1.5, Math.PI * 2);
            cr.arc (x + width - radius, y + height - radius, radius, 0, Math.PI * 0.5);
            cr.arc (x + radius, y + height - radius, radius, Math.PI * 0.5, Math.PI);
            cr.arc (x + radius, y + radius, radius, Math.PI, Math.PI * 1.5);
            cr.close_path ();
    }
}
