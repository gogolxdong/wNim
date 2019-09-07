#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                 (c) Copyright 2017-2019 Ward
#
#====================================================================

## A brush is a drawing tool for filling in areas.
#
## :Superclass:
##   `wGdiObject <wGdiObject.html>`_
#
## :Seealso:
##   `wDC <wDC.html>`_
#
## :Consts:
##   ==============================  =============================================================
##   Font Family                     Description
##   ==============================  =============================================================
##   wBrushStyleSolid                Solid.
##   wBrushStyleTransparent          Transparent (no fill).
##   wBrushStyleMask                 Brush style mask.
##   wBrushStyleBdiagonalHatch       Backward diagonal hatch.
##   wBrushStyleCrossdiagHatch       Cross-diagonal hatch.
##   wBrushStyleFdiagonalHatch       Forward diagonal hatch.
##   wBrushStyleCrossHatch           Cross hatch.
##   wBrushStyleHorizontalHatch      Horizontal hatch.
##   wBrushStyleVerticalHatch        Vertical hatch.
##   wBrushStyleMaskHatch            Brush hatch style mask.
##   ==============================  =============================================================

{.experimental, deadCodeElim: on.}

import ../wBase, wGdiObject
export wGdiObject

type
  wBrushError* = object of wGdiObjectError
    ## An error raised when wBrush creation failed.

const
  wBrushStyleSolid* = PS_SOLID
  wBrushStyleTransparent* = PS_NULL
  wBrushStyleMask* = PS_STYLE_MASK
  wBrushStyleBdiagonalHatch* = HS_BDIAGONAL shl 16
  wBrushStyleCrossdiagHatch* = HS_DIAGCROSS shl 16
  wBrushStyleFdiagonalHatch* = HS_FDIAGONAL shl 16
  wBrushStyleCrossHatch* = HS_CROSS shl 16
  wBrushStyleHorizontalHatch* = HS_HORIZONTAL shl 16
  wBrushStyleVerticalHatch* = HS_VERTICAL shl 16
  wBrushStyleMaskHatch* = 0x00ff0000

proc setup(self: wBrush, lb: LOGBRUSH) =
  self.mColor = lb.lbColor
  self.mStyle = lb.lbStyle or (lb.lbHatch.DWORD shl 16)

wClass(wBrush of wGdiObject):

  proc final*(self: wBrush) =
    ## Default finalizer for wBrush.
    self.delete()

  proc init*(self: wBrush, lb: var LOGBRUSH) =
    ## Initializes a brush from LOGBRUSH struct. Used internally.
    self.wGdiObject.init()

    self.mHandle = CreateBrushIndirect(lb)
    if self.mHandle == 0:
      raise newException(wBrushError, "wBrush creation failed")

    self.setup(lb)

  proc init*(self: wBrush, color: wColor = wWHITE, style = wBrushStyleSolid) {.validate.} =
    ## Initializes a brush from a color and style.
    let hatch = style shr 16
    var lb: LOGBRUSH
    lb.lbColor = color

    if (style and wBrushStyleMask) == wBrushStyleTransparent:
      lb.lbStyle = BS_HOLLOW
    elif hatch != 0:
      lb.lbStyle = BS_HATCHED
      lb.lbHatch = ULONG_PTR hatch
    else:
      lb.lbStyle = BS_SOLID

    self.init(lb)

  proc init*(self: wBrush, hBrush: HANDLE, copy = true, shared = false) {.validate.} =
    ## Initializes a brush from system brush handle.
    ## If *copy* is false, the function only wrap the handle to wBrush object.
    ## If *shared* is false, the handle will be destroyed together with wBrush
    ## object by the GC. Otherwise, the caller is responsible for destroying it.
    var lb: LOGBRUSH
    if GetObject(hBrush, sizeof(LOGBRUSH), &lb) == 0:
      raise newException(wBrushError, "wBrush creation failed")

    if copy:
      self.init(lb)
    else:
      self.wGdiObject.init()
      self.mHandle = hBrush
      self.mDeletable = not shared
      self.setup(lb)

  proc init*(self: wBrush, brush: wBrush) {.validate.} =
    ## Initializes a brush from a wBrush object, aka. copy.
    self.init(brush.mHandle, copy=true)

proc getColor*(self: wBrush): wColor {.validate, property, inline.} =
  ## Returns a reference to the brush color.
  result = self.mColor

proc getStyle*(self: wBrush): DWORD {.validate, property, inline.} =
  ## Returns the brush style.
  result = self.mStyle

proc setColor*(self: wBrush, color: wColor) {.validate, property.} =
  ## Sets the brush color.
  DeleteObject(self.mHandle)
  self.init(color=color, style=self.mStyle)

proc setStyle*(self: wBrush, style: DWORD) {.validate, property.} =
  ## Sets the brush style.
  DeleteObject(self.mHandle)
  self.init(color=self.mColor, style=style)

template wBlackBrush*(): untyped =
  ## Predefined black brush. **Don't delete**.
  wGDIStock(wBrush, BlackBrush):
    Brush(color=wBLACK)

template wWhiteBrush*(): untyped =
  ## Predefined white brush. **Don't delete**.
  wGDIStock(wBrush, WhiteBrush):
    Brush(color=wWHITE)

template wGreyBrush*(): untyped =
  ## Predefined grey brush. **Don't delete**.
  wGDIStock(wBrush, GreyBrush):
    Brush(color=wGREY)

template wTransparentBrush*(): untyped =
  ## Predefined transparent brush. **Don't delete**.
  wGDIStock(wBrush, TransparentBrush):
    Brush(style=wBrushStyleTransparent)

template wLightGreyBrush*(): untyped =
  ## Predefined light grey brush. **Don't delete**.
  wGDIStock(wBrush, LightGreyBrush):
    Brush(color=wLIGHTGREY)

template wMediumGreyBrush*(): untyped =
  ## Predefined medium grey brush. **Don't delete**.
  wGDIStock(wBrush, MediumGreyBrush):
    Brush(color=wMEDIUMGREY)

template wBlueBrush*(): untyped =
  ## Predefined blue brush. **Don't delete**.
  wGDIStock(wBrush, BlueBrush):
    Brush(color=wBLUE)

template wGreenBrush*(): untyped =
  ## Predefined green brush. **Don't delete**.
  wGDIStock(wBrush, GreenBrush):
    Brush(color=wGREEN)

template wCyanBrush*(): untyped =
  ## Predefined cyan brush. **Don't delete**.
  wGDIStock(wBrush, CyanBrush):
    Brush(color=wCYAN)

template wRedBrush*(): untyped =
  ## Predefined red brush. **Don't delete**.
  wGDIStock(wBrush, RedBrush):
    Brush(color=wRED)

template wDefaultBrush*(): untyped =
  ## Predefined default (white) brush. **Don't delete**.
  wWhiteBrush()
