STYLE = {
    ACTIONBARBUTTON = {
        bg_color = COLOR.BLUE,
        highlight_color = COLOR.BLACK,
        dependencyTable = {},

        onClick = function (self)
            ROOT.computeLayout()
            self.w = self.w + self.parent.padding + self.margin
            print(self.dependencyIndex)
        end
    }
}

return STYLE