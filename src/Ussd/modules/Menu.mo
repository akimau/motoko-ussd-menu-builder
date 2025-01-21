import MenuItem "MenuItem";

module Menu {
    type MenuItem = MenuItem.MenuItem;

    public type Menu = {
        id : Text;
        description : Text;
        menuItems : [MenuItem];
        startMenuItemId : Text; // the id of the start menu item
    };
};
