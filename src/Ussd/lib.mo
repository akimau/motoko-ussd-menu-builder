import Menu "modules/Menu";
import MenuItem "modules/MenuItem";
import Session "modules/Session";
import Args "modules/Args";
import MenuOption "modules/MenuOption";

module {
    public let { new = newMenu } = Menu;

    public let { addMenuItem; getStartMenuItem } = Menu;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public let { new = newMenuItem; newWithOptions = newMenuItemWithOptions } = MenuItem;

    public let { getMenuOption; hasNext } = MenuItem;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public let { new = newMenuOption } = MenuOption;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public let { new = newArgs } = Args;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public let { new = newSession } = Session;
};
