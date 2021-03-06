# $FreeBSD: head/lang/swift/Makefile 422711 2016-09-24 11:06:57Z tijl $

PORTNAME=	swift
PORTVERSION=	3.0.1
PORTREVISION=	4
CATEGORIES=	lang

MAINTAINER=	swills@FreeBSD.org
COMMENT=	Swift programing language

LICENSE=	APACHE20
LICENSE_FILE=	${WRKSRC}/swift/LICENSE.txt

BUILD_DEPENDS=	cmake:devel/cmake \
		bash:shells/bash \
		swig:devel/swig13 \
		python:lang/python \
		sphinx-build:textproc/py-sphinx \
		binutils>=2.25.1:devel/binutils
LIB_DEPENDS=	libicudata.so:devel/icu \
		libuuid.so:misc/e2fsprogs-libuuid

USE_GITHUB=	yes
GH_ACCOUNT=	apple:DEFAULT,llvm,clang,lldb,cmark,llbuild,swiftpm,xctest,xcfound
GH_PROJECT=	swift:DEFAULT swift-llvm:llvm swift-clang:clang swift-lldb:lldb \
		swift-cmark:cmark swift-llbuild:llbuild swift-package-manager:swiftpm \
		swift-corelibs-xctest:xctest swift-corelibs-foundation:xcfound
GH_TAGNAME=	swift-${PORTVERSION}-RELEASE:DEFAULT,llvm,clang,lldb,cmark,llbuild,swiftpm,xctest,xcfound

WRKSRC=		${WRKDIR}/${PORTNAME}-${PORTVERSION}
USES=		iconv libedit ninja perl5 pkgconfig python:3,build sqlite

USE_GNOME=	libxml2
USE_LDCONFIG=	yes
ONLY_FOR_ARCHS=	amd64
CONFLICTS_BUILD=	googletest

OPTIONS_DEFINE=	DOCS

PORTDOCS=	*

.include <bsd.port.pre.mk>

.if ${OPSYS} == FreeBSD
.if (${OSVERSION} < 1002000) || (${OSVERSION} < 1100079)
BUILD_DEPENDS+=	clang38:devel/llvm38
EXTRA_FLAGS=	--host-cc=${LOCALBASE}/bin/clang38 --host-cxx=${LOCALBASE}/bin/clang++38
.endif
.if (${OSVERSION} < 1001513)
BROKEN=		Does not build
.endif
.endif

post-extract:
	@${MKDIR} ${WRKSRC}
	@${MV} ${WRKDIR}/${PORTNAME}-${PORTNAME}-${PORTVERSION}-RELEASE ${WRKSRC}/swift
	@${MV} ${WRKSRC_llvm} ${WRKSRC}/llvm
	@${MV} ${WRKSRC_clang} ${WRKSRC}/clang
	@${MV} ${WRKSRC_lldb} ${WRKSRC}/lldb
	@${MV} ${WRKSRC_cmark} ${WRKSRC}/cmark
	@${MV} ${WRKSRC_llbuild} ${WRKSRC}/llbuild
	@${MV} ${WRKSRC_swiftpm} ${WRKSRC}/swiftpm
	@${MV} ${WRKSRC_xctest} ${WRKSRC}/swift-corelibs-xctest
	@${MV} ${WRKSRC_xcfound} ${WRKSRC}/swift-corelibs-foundation

post-patch:
	@${REINPLACE_CMD} -e 's|%%LOCALBASE%%|${LOCALBASE}|g' \
		${WRKSRC}/swift/cmake/modules/SwiftSharedCMakeConfig.cmake

do-build:
	@${MKDIR} ${STAGEDIR}${PREFIX}
	cd ${WRKSRC}/swift; ${SETENV} PATH=${LOCALBASE}/bin:${PATH} \
		CPPFLAGS="-I${LOCALBASE}/include ${CPPFLAGS}" \
		CFLAGS="-I${LOCALBASE}/include ${CFLAGS}" \
		CXXFLAGS="-I${LOCALBASE}/include ${CXXFLAGS}" \
		LDFLAGS='-B${LOCALBASE}/bin' \
		install_destdir=${STAGEDIR} \
                LANG=en_US.UTF-8 \
		./utils/build-script --host-target freebsd-x86_64 -R --no-assertions \
		--llbuild \
		-- \
		${EXTRA_FLAGS} \
                --use-gold-linker \
		--verbose-build \
		--install-swift \
		--install-llbuild \
		--install_prefix=${PREFIX} \
		--install_destdir=${STAGEDIR} \
		--swift-install-components='compiler;clang-builtin-headers;stdlib;sdk-overlay;license;tools;editor-integration' \
		--build-swift-static-stdlib=1 \
		--skip-test-lldb=1
	@${RM} /var/run/libuuid/clock.txt /var/run/libuuid/request /var/run/libuuid/uuidd.pid

do-install:
	${MV} ${STAGEDIR}${PREFIX}/share/man/man1/swift.1 ${STAGEDIR}${PREFIX}/man/man1/swift.1
	${RM} -r ${STAGEDIR}${PREFIX}/share/man
	${GZIP_CMD} ${STAGEDIR}${PREFIX}/man/man1/swift.1
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/lib/swift/freebsd/libswiftGlibc.so
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/lib/swift/freebsd/libswiftCore.so
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/swift-compress
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/sil-extract
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/swift-ide-test
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/swift-llvm-opt
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/swift-build-tool
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/swift
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/swift-demangle
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/sil-opt

do-install-DOCS-on:
	cd ${WRKSRC}/build/Ninja-Release/swift-freebsd-x86_64/docs/html ; \
		${COPYTREE_SHARE} . ${STAGEDIR}${DOCSDIR}

.include <bsd.port.post.mk>
