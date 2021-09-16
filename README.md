# CircularScrollImageView
------------
### Overview
> 다양한 앱에서 자주 사용하는 Circular infinite iamge scollView를 모듈화하여,
> 간편하게 사용할 수 있도록 작업하였습니다.

### Usage
* Requirements
> Drag&Drop [ScrollImageView.swift]

* Basics
``` Swift
/// Set ScrollImageView
private var scrollImageView: ScrollImageView!

/// In some function or life-cycle
scrollImageView = ScrollImageView(frame: self.view.frame)
self.view.addSubview(scrollImageView)

scrollImageView.reloadData([YOUR IMAGES], configuration: nil)

```

* Customizing configuration
``` Swift
/// Pre-define
struct ScrollImageViewConfiguration {
    var usePageControl: Bool = true
    var contentMode: UIView.ContentMode = .scaleAspectFit
}

/// Usage
var configuration = ScrollImageViewConfiguration()
configuration.contentMode = .scaleAspectFit

scrollImageView.reloadData([YOUR IMAGES], configuration: configuration)
```

* Image Click Action CallBack
``` Swift
scrollImageView.onClickImageHandler = { (index) in
  // do something
}
```
