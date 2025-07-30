import 'package:bot_toast/bot_toast.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:badges/badges.dart' as badges;

typedef BaseScreenUtil = ScreenUtil;
typedef BaseScreenUtilInit = ScreenUtilInit;

typedef BaseOverlayVisibilityMode = OverlayVisibilityMode;

typedef BaseDateFormat = DateFormat;
typedef BaseIntl = Intl;

typedef BaseExtendedImage = ExtendedImage;
typedef BaseExtendedImageState = ExtendedImageState;
typedef BaseExtendedImageProvider = ExtendedImageProvider;
typedef BaseExtendedFileImageProvider = ExtendedFileImageProvider;
typedef BaseExtendedNetworkImageProvider = ExtendedNetworkImageProvider;
typedef BaseExtendedAssetImageProvider = ExtendedAssetImageProvider;
typedef BaseExtendedExactAssetImageProvider = ExtendedExactAssetImageProvider;
typedef BaseLoadState = LoadState;
typedef BaseImageEditorController = ImageEditorController;
typedef BaseExtendedImageMode = ExtendedImageMode;
typedef BaseExtendedImageEditorState = ExtendedImageEditorState;
typedef BaseExtendedResizeImage = ExtendedResizeImage;
typedef BaseEditorConfig = EditorConfig;
typedef BaseEditActionDetails = EditActionDetails;
typedef BaseCropAspectRatios = CropAspectRatios;

typedef BaseSwiper = Swiper;
typedef BaseSwiperLayout = SwiperLayout;
typedef BaseSwiperPlugin = SwiperPlugin;
typedef BaseSwiperPagination = SwiperPagination;
typedef BaseDotSwiperPaginationBuilder = DotSwiperPaginationBuilder;
typedef BaseRectSwiperPaginationBuilder = RectSwiperPaginationBuilder;
typedef BaseFractionPaginationBuilder = FractionPaginationBuilder;

typedef BaseCancelToken = CancelToken;

typedef BaseEasyLoading = EasyLoading;
typedef BaseEasyLoadingStyle = EasyLoadingStyle;
typedef BaseEasyLoadingToastPosition = EasyLoadingToastPosition;
typedef BaseEasyLoadingAnimationStyle = EasyLoadingAnimationStyle;
typedef BaseEasyLoadingMaskType = EasyLoadingMaskType;
typedef BaseEasyLoadingIndicatorType = EasyLoadingIndicatorType;
typedef BaseEasyLoadingStatus = EasyLoadingStatus;

typedef BaseBotToast = BotToast;

typedef BaseAlignedGridView = AlignedGridView;
typedef BaseMasonryGridView = MasonryGridView;
typedef BaseStaggeredGrid = StaggeredGrid;
typedef BaseSliverAlignedGrid = SliverAlignedGrid;
typedef BaseSliverMasonryGrid = SliverMasonryGrid;
typedef BaseStaggeredGridTile = StaggeredGridTile;
typedef BaseSliverSimpleGridDelegateWithFixedCrossAxisCount
    = SliverSimpleGridDelegateWithFixedCrossAxisCount;
typedef BaseSliverSimpleGridDelegateWithMaxCrossAxisExtent
    = SliverSimpleGridDelegateWithMaxCrossAxisExtent;
typedef BaseSliverStairedGridDelegate = SliverStairedGridDelegate;
typedef BaseStairedGridTile = StairedGridTile;
typedef BaseSliverQuiltedGridDelegate = SliverQuiltedGridDelegate;
typedef BaseQuiltedGridTile = QuiltedGridTile;
typedef BaseQuiltedGridRepeatPattern = QuiltedGridRepeatPattern;
typedef BaseSliverWovenGridDelegate = SliverWovenGridDelegate;
typedef BaseWovenGridTile = WovenGridTile;

typedef BaseSmartRefresher = SmartRefresher;
typedef BaseRefreshController = RefreshController;
typedef BaseRefreshLocalizations = RefreshLocalizations;
typedef BaseRefreshConfiguration = RefreshConfiguration;
typedef BaseClassicHeader = ClassicHeader;
typedef BaseClassicFooter = ClassicFooter;
typedef BaseCustomFooter = CustomFooter;

typedef BaseRatingBar = RatingBar;
typedef BaseRatingWidget = RatingWidget;

typedef BasePhotoViewGallery = PhotoViewGallery;
typedef BasePhotoViewGalleryPageOptions = PhotoViewGalleryPageOptions;
typedef BasePhotoViewComputedScale = PhotoViewComputedScale;
typedef BasePhotoViewHeroAttributes = PhotoViewHeroAttributes;

typedef BaseDynamicFont = DynamicFont;

typedef BaseSvgPicture = SvgPicture;

typedef BaseBadge = badges.Badge;
typedef BaseBadgeAnimationType = badges.BadgeAnimationType;
typedef BaseBadgePosition = badges.BadgePosition;
typedef BaseBadgePositioned = badges.BadgePositioned;
typedef BaseBadgeShape = badges.BadgeShape;
typedef BaseBadgeStyle = badges.BadgeStyle;
typedef BaseBadgeAnimation = badges.BadgeAnimation;
typedef BaseBadgeBadgeGradient = badges.BadgeGradient;
