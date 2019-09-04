#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                 (c) Copyright 2017-2019 Ward
#
#====================================================================

## These events are generated by wWindow when the mouse moves or clicks.
#
## :Superclass:
##   `wEvent <wEvent.html>`_
#
## :Seealso:
##   `wWindow <wWindow.html>`_
#
## :Events:
##   ==============================  =============================================================
##   wMouseEvent (client)            Description
##   ==============================  =============================================================
##   wEvent_LeftDown                 The left button was pressed.
##   wEvent_LeftUp                   The left button was released.
##   wEvent_MiddleDown               The middle button was pressed.
##   wEvent_MiddleUp                 The middle button was released.
##   wEvent_RightDown                The right button was pressed.
##   wEvent_RightUp                  The right button was released.
##   wEvent_Motion                   Same as wEvent_MouseMove.
##   wEvent_MouseMove                The cursor moves.
##   wEvent_LeftDoubleClick          The the left button was double-clicked
##   wEvent_MiddleDoubleClick        The the middle button was double-clicked
##   wEvent_RightDoubleClick         The the right button was double-clicked
##
##   wMouseEvent (nonclient)         Description
##   ==============================  =============================================================
##   wEvent_NcLeftDown               wEvent_LeftDown within the nonclient area
##   wEvent_NcLeftUp                 wEvent_LeftUp within the nonclient area
##   wEvent_NcMiddleDown             wEvent_MiddleDown within the nonclient area
##   wEvent_NcMiddleUp               wEvent_MiddleUp within the nonclient area
##   wEvent_NcRightDown              wEvent_RightDown within the nonclient area
##   wEvent_NcRightUp                wEvent_RightUp within the nonclient area
##   wEvent_NcMotion                 wEvent_Motion within the nonclient area
##   wEvent_NcMouseMotion            wEvent_MouseMove within the nonclient area
##   wEvent_NcLeftDoubleClick        wEvent_LeftDoubleClick within the nonclient area
##   wEvent_NcMiddleDoubleClick      wEvent_MiddleDoubleClick within the nonclient area
##   wEvent_NcRightDoubleClick       wEvent_RightDoubleClick within the nonclient area
##
##   wMouseEvent (others)            Description
##   ==============================  =============================================================
##   wEvent_MouseWheel               The mouse wheel is rotated.
##   wEvent_MouseHorizontalWheel     The mouse's horizontal scroll wheel is tilted or rotated.
##   wEvent_MouseEnter               When the cursor enters the client area of the window
##   wEvent_MouseLeave               When the cursor leaves the client area of the window
##   wEvent_MouseHover               When the cursor hovers over the client area of the window for the period of time.
##   ==============================  =============================================================

{.experimental, deadCodeElim: on.}

import ../wBase

const
  # WM_MOUSEFIRST
  wEvent_Motion* = WM_MOUSEMOVE
  wEvent_MouseMove* = WM_MOUSEMOVE
  wEvent_LeftDown* = WM_LBUTTONDOWN
  wEvent_LeftUp* = WM_LBUTTONUP
  wEvent_LeftDoubleClick* = WM_LBUTTONDBLCLK
  wEvent_RightDown* = WM_RBUTTONDOWN
  wEvent_RightUp* = WM_RBUTTONUP
  wEvent_RightDoubleClick* = WM_RBUTTONDBLCLK
  wEvent_MiddleDown* = WM_MBUTTONDOWN
  wEvent_MiddleUp* = WM_MBUTTONUP
  wEvent_MiddleDoubleClick* = WM_MBUTTONDBLCLK
  wEvent_MouseWheel* = WM_MOUSEWHEEL
  wEvent_MouseHorizontalWheel* = WM_MOUSEHWHEEL
  #WM_MOUSELAST

  wEvent_NcMouseMove* = WM_NCMOUSEMOVE # 0xA0
  wEvent_NcMotion* = WM_NCMOUSEMOVE
  wEvent_NcLeftDown* = WM_NCLBUTTONDOWN
  wEvent_NcLeftUp* = WM_NCLBUTTONUP
  wEvent_NcLeftDoubleClick* = WM_NCLBUTTONDBLCLK
  wEvent_NcRightDown* = WM_NCRBUTTONDOWN
  wEvent_NcRightUp* = WM_NCRBUTTONUP
  wEvent_NcRightDoubleClick* = WM_NCRBUTTONDBLCLK
  wEvent_NcMiddleDown* = WM_NCMBUTTONDOWN
  wEvent_NcMiddleUp* = WM_NCMBUTTONUP
  wEvent_NcMiddleDoubleClick* = WM_NCMBUTTONDBLCLK
  # WM_NCXBUTTONDBLCLK == 0xAD

  wEvent_MouseLeave* = WM_MOUSELEAVE # 0x02A3
  wEvent_MouseHover* = WM_MOUSEHOVER # 0x02A1
  wEvent_MouseEnter* = wEventId()

proc isMouseEvent(msg: UINT): bool {.inline, shield.} =
  (msg in WM_MOUSEFIRST..WM_MOUSELAST) or (msg in 0xA0..0xAD) or
    msg in {wEvent_MouseLeave, wEvent_MouseHover, wEvent_MouseEnter}

method getWheelRotation*(self: wMouseEvent): int {.property.} =
  ## Get wheel rotation, positive or negative indicates direction of rotation.
  if self.mMsg == wEvent_MouseWheel:
    result = int GET_WHEEL_DELTA_WPARAM(self.mWparam)
