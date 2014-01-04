SSRollingButtonScrollView
=========================

SSRollingButtonScrollView is a custom UIScrollView subclass that features an infinite looping scroll of UIButtons. Users of SSRollingButtonScrollView must, at minimum, provide an array of button titles and specify a layout style (horizontal scrolling or vertical scrolling). Through the implementation of the optional delegate methods, the user is informed of any button being pushed (touchUpInside), any button being scrolled to the center of the view, and most of the UIScrollViewDelegate methods (some are not available as they interfere with the working of the SSRollingButtonScrollView). The inifinite scrolling code is based on Apple's InfiniteScrollView class found in the StreetScroller sample project.
