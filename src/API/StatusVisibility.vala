public enum Tootle.StatusVisibility {
    PUBLIC,
    UNLISTED,
    PRIVATE,
    DIRECT;

    public string to_string() {
        switch (this) {
            case PUBLIC:
                return "public";
            case UNLISTED:
                return "unlisted";
            case PRIVATE:
                return "private";
            case DIRECT:
                return "direct";
            default:
                assert_not_reached();
        }
    }
    
    public static StatusVisibility from_string (string str) {
        switch (str) {
            case "public":
                return StatusVisibility.PUBLIC;
            case "unlisted":
                return StatusVisibility.UNLISTED;
            case "private":
                return StatusVisibility.PRIVATE;
            case "direct":
                return StatusVisibility.DIRECT;
            default:
                assert_not_reached();
        }
    }
    // TODO: write better descriptions for Post Visibilities
    public string get_desc() {
        switch (this) {
            case PUBLIC:
                return _("Post to the public timeline.");
            case UNLISTED:
                return _("Don\'t post to the public timeline.");
            case PRIVATE:
                return _("Post to your followers only.");
            case DIRECT:
                return _("Send a direct message to mentioned users.");
            default:
                assert_not_reached();
        }
    }

    public string get_icon() {
        switch (this) {
            case PUBLIC:
                return "system-users-symbolic";
            case UNLISTED:
                return "changes-allow-symbolic";
            case PRIVATE:
                return "changes-prevent-symbolic";
            case DIRECT:
                return "mail-unread-symbolic";
            default:
                assert_not_reached();
        }
    }
    
}
