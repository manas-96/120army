import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../exports.dart';
import '../../global.dart';

class Webviewurl extends StatefulWidget {
  const Webviewurl({super.key, required this.webUrl, required this.title});

  final String webUrl;
  final String title;

  @override
  State<Webviewurl> createState() => _WebviewurlState();
}

class _WebviewurlState extends State<Webviewurl> {
  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: kPrimaryColor),
      onRefresh: () async {
        if (webViewController != null) {
          if (await webViewController!.canGoBack()) {
            webViewController!.reload();
          } else {
            webViewController!.loadUrl(
              urlRequest: URLRequest(url: WebUri(widget.webUrl)),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.webUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              mediaPlaybackRequiresUserGesture: false,
              useHybridComposition: true,
              allowsInlineMediaPlayback: true,
            ),
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
              pullToRefreshController.endRefreshing();
            },
            onReceivedError: (controller, request, error) {
              pullToRefreshController.endRefreshing();
            },
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
