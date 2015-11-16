From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v2 2/3] [media] include/media: move driver
	interface headers to a separate dir
Date: Mon, 16 Nov 2015 09:00:44 -0200
Message-ID: <23e53dd0223c40ecf7128e0b270fcfbea8e1c43b.1447671420.git.mchehab@osg.samsung.com>
References: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
In-Reply-To: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
References: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
Cc: Abhilash Jindal <klock.android@gmail.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, linux-sh@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>, Hans Verkuil <hverkuil@xs4all.nl>, Andrzej Hajda <a.hajda@samsung.com>, "Lad,
 Prabhakar" <prabhakar.csengg@gmail.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>, Matthias Schwarzott <zzam@gentoo.org>, linux-api@vger.kernel.org, Olli Salonen <olli.salonen@iki.fi>, Alexey Khoroshilov <khoroshilov@ispras.ru>, Antti Palosaari <crope@iki.fi>, Lars-Peter Clausen <lars@metafoo.de>, Pawel Osciak <pawel@osciak.com>, Vinod Koul <vinod.koul@intel.com>, Quentin Lambert <lambert.quentin@gmail.com>, Kukjin Kim <kgene@kernel.org>, Jiri Slaby <jslaby@suse.com>, Junghak Sung <jh1009.sung@samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Ondrej Zary <linux@rainb>
List-Id: linux-api@vger.kernel.org

Let's not mix headers used by the core with those headers that
are needed by some driver-specific interface header.

The headers used on drivers were manually moved using:
    mkdir include/media/drv-intf/
    git mv include/media/cx2341x.h include/media/cx25840.h \
	include/media/exynos-fimc.h include/media/msp3400.h \
	include/media/s3c_camif.h include/media/saa7146.h \
	include/media/saa7146_vv.h  include/media/sh_mobile_ceu.h \
	include/media/sh_mobile_csi2.h include/media/sh_vou.h \
	include/media/si476x.h include/media/soc_mediabus.h \
	include/media/tea575x.h include/media/drv-intf/

And the references for those headers were corrected using:

    MAIN_DIR="media/"
    PREV_DIR="media/"
    DIRS="drv-intf/"

    echo "Checking affected files" >&2
    for i in $DIRS; do
	for j in $(find include/$MAIN_DIR/$i -type f -name '*.h'); do
		 n=`basename $j`
		git grep -l $n
	done
    done|sort|uniq >files && (
	echo "Handling files..." >&2;
	echo "for i in \$(cat files|grep -v Documentation); do cat \$i | \\";
	(
		cd include/$MAIN_DIR;
		for j in $DIRS; do
			for i in $(ls $j); do
				echo "perl -ne 's,(include [\\\"\\<])$PREV_DIR($i)([\\\"\\>]),\1$MAIN_DIR$j\2\3,; print \$_' |\\";
			done;
		done;
		echo "cat > a && mv a \$i; done";
	);
	echo "Handling documentation..." >&2;
	echo "for i in MAINTAINERS \$(cat files); do cat \$i | \\";
	(
		cd include/$MAIN_DIR;
		for j in $DIRS; do
			for i in $(ls $j); do
				echo "  perl -ne 's,include/$PREV_DIR($i)\b,include/$MAIN_DIR$j\1,; print \$_' |\\";
			done;
		done;
		echo "cat > a && mv a \$i; done"
	);
    ) >script && . ./script

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 MAINTAINERS                                              | 4 ++--
 arch/sh/boards/mach-ap325rxa/setup.c                     | 2 +-
 arch/sh/boards/mach-ecovec24/setup.c                     | 4 ++--
 arch/sh/boards/mach-kfr2r09/setup.c                      | 2 +-
 arch/sh/boards/mach-migor/setup.c                        | 2 +-
 arch/sh/boards/mach-se/7724/setup.c                      | 4 ++--
 drivers/media/common/cx2341x.c                           | 2 +-
 drivers/media/common/saa7146/saa7146_core.c              | 2 +-
 drivers/media/common/saa7146/saa7146_fops.c              | 2 +-
 drivers/media/common/saa7146/saa7146_hlp.c               | 2 +-
 drivers/media/common/saa7146/saa7146_i2c.c               | 2 +-
 drivers/media/common/saa7146/saa7146_vbi.c               | 2 +-
 drivers/media/common/saa7146/saa7146_video.c             | 2 +-
 drivers/media/i2c/cx25840/cx25840-audio.c                | 2 +-
 drivers/media/i2c/cx25840/cx25840-core.c                 | 2 +-
 drivers/media/i2c/cx25840/cx25840-firmware.c             | 2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c                   | 2 +-
 drivers/media/i2c/cx25840/cx25840-vbi.c                  | 2 +-
 drivers/media/i2c/m5mols/m5mols_capture.c                | 2 +-
 drivers/media/i2c/msp3400-driver.c                       | 2 +-
 drivers/media/i2c/msp3400-driver.h                       | 2 +-
 drivers/media/i2c/msp3400-kthreads.c                     | 2 +-
 drivers/media/i2c/soc_camera/mt9m001.c                   | 2 +-
 drivers/media/i2c/soc_camera/mt9v022.c                   | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c                    | 2 +-
 drivers/media/pci/bt8xx/bttvp.h                          | 2 +-
 drivers/media/pci/cx18/cx23418.h                         | 2 +-
 drivers/media/pci/cx23885/cx23885-417.c                  | 2 +-
 drivers/media/pci/cx23885/cx23885-cards.c                | 2 +-
 drivers/media/pci/cx23885/cx23885-video.c                | 2 +-
 drivers/media/pci/cx23885/cx23885.h                      | 2 +-
 drivers/media/pci/cx88/cx88-blackbird.c                  | 2 +-
 drivers/media/pci/cx88/cx88.h                            | 2 +-
 drivers/media/pci/ivtv/ivtv-cards.c                      | 4 ++--
 drivers/media/pci/ivtv/ivtv-driver.h                     | 2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                        | 2 +-
 drivers/media/pci/ivtv/ivtv-routing.c                    | 2 +-
 drivers/media/pci/saa7146/hexium_gemini.c                | 2 +-
 drivers/media/pci/saa7146/hexium_orion.c                 | 2 +-
 drivers/media/pci/saa7146/mxb.c                          | 2 +-
 drivers/media/pci/ttpci/av7110.h                         | 2 +-
 drivers/media/pci/ttpci/budget-av.c                      | 2 +-
 drivers/media/pci/ttpci/budget.h                         | 2 +-
 drivers/media/platform/exynos4-is/common.c               | 2 +-
 drivers/media/platform/exynos4-is/fimc-core.h            | 2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c       | 2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h             | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c        | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c            | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.h            | 2 +-
 drivers/media/platform/exynos4-is/fimc-reg.c             | 2 +-
 drivers/media/platform/exynos4-is/media-dev.c            | 2 +-
 drivers/media/platform/exynos4-is/media-dev.h            | 2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c            | 2 +-
 drivers/media/platform/s3c-camif/camif-core.h            | 2 +-
 drivers/media/platform/s3c-camif/camif-regs.h            | 2 +-
 drivers/media/platform/sh_vou.c                          | 2 +-
 drivers/media/platform/soc_camera/atmel-isi.c            | 2 +-
 drivers/media/platform/soc_camera/mx2_camera.c           | 2 +-
 drivers/media/platform/soc_camera/mx3_camera.c           | 2 +-
 drivers/media/platform/soc_camera/omap1_camera.c         | 2 +-
 drivers/media/platform/soc_camera/pxa_camera.c           | 2 +-
 drivers/media/platform/soc_camera/rcar_vin.c             | 2 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 6 +++---
 drivers/media/platform/soc_camera/sh_mobile_csi2.c       | 6 +++---
 drivers/media/platform/soc_camera/soc_camera.c           | 2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c         | 2 +-
 drivers/media/radio/radio-maxiradio.c                    | 2 +-
 drivers/media/radio/radio-sf16fmr2.c                     | 2 +-
 drivers/media/radio/radio-shark.c                        | 2 +-
 drivers/media/radio/radio-si476x.c                       | 2 +-
 drivers/media/radio/tea575x.c                            | 2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c                  | 2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c                | 2 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c                  | 2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                | 2 +-
 drivers/media/usb/cx231xx/cx231xx.h                      | 2 +-
 drivers/media/usb/em28xx/em28xx-cards.c                  | 2 +-
 drivers/media/usb/em28xx/em28xx-video.c                  | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-audio.c                | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c          | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h         | 2 +-
 include/media/{ => drv-intf}/cx2341x.h                   | 0
 include/media/{ => drv-intf}/cx25840.h                   | 0
 include/media/{ => drv-intf}/exynos-fimc.h               | 0
 include/media/{ => drv-intf}/msp3400.h                   | 1 -
 include/media/{ => drv-intf}/s3c_camif.h                 | 0
 include/media/{ => drv-intf}/saa7146.h                   | 0
 include/media/{ => drv-intf}/saa7146_vv.h                | 2 +-
 include/media/{ => drv-intf}/sh_mobile_ceu.h             | 0
 include/media/{ => drv-intf}/sh_mobile_csi2.h            | 0
 include/media/{ => drv-intf}/sh_vou.h                    | 0
 include/media/{ => drv-intf}/si476x.h                    | 2 +-
 include/media/{ => drv-intf}/soc_mediabus.h              | 0
 include/media/{ => drv-intf}/tea575x.h                   | 0
 include/uapi/linux/v4l2-controls.h                       | 6 ++++--
 sound/pci/es1968.c                                       | 2 +-
 sound/pci/fm801.c                                        | 2 +-
 98 files changed, 98 insertions(+), 97 deletions(-)
 rename include/media/{ => drv-intf}/cx2341x.h (100%)
 rename include/media/{ => drv-intf}/cx25840.h (100%)
 rename include/media/{ => drv-intf}/exynos-fimc.h (100%)
 rename include/media/{ => drv-intf}/msp3400.h (99%)
 rename include/media/{ => drv-intf}/s3c_camif.h (100%)
 rename include/media/{ => drv-intf}/saa7146.h (100%)
 rename include/media/{ => drv-intf}/saa7146_vv.h (99%)
 rename include/media/{ => drv-intf}/sh_mobile_ceu.h (100%)
 rename include/media/{ => drv-intf}/sh_mobile_csi2.h (100%)
 rename include/media/{ => drv-intf}/sh_vou.h (100%)
 rename include/media/{ => drv-intf}/si476x.h (94%)
 rename include/media/{ => drv-intf}/soc_mediabus.h (100%)
 rename include/media/{ => drv-intf}/tea575x.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index a8e3f478d869..dc1787719c2a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9225,7 +9225,7 @@ L:	linux-media@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/media/platform/s3c-camif/
-F:	include/media/s3c_camif.h
+F:	include/media/drv-intf/s3c_camif.h
 
 SAMSUNG S5C73M3 CAMERA DRIVER
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -9686,7 +9686,7 @@ SH_VOU V4L2 OUTPUT DRIVER
 L:	linux-media@vger.kernel.org
 S:	Orphan
 F:	drivers/media/platform/sh_vou.c
-F:	include/media/sh_vou.h
+F:	include/media/drv-intf/sh_vou.h
 
 SIMPLE FIRMWARE INTERFACE (SFI)
 M:	Len Brown <lenb@kernel.org>
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 62b045c6d289..d642a77d1913 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -30,7 +30,7 @@
 #include <media/i2c/ov772x.h>
 #include <media/soc_camera.h>
 #include <media/soc_camera_platform.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
 #include <asm/io.h>
 #include <asm/clock.h>
diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 5fcec7648d52..a9c0c07386fd 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -38,7 +38,7 @@
 #include <video/sh_mobile_lcdc.h>
 #include <sound/sh_fsi.h>
 #include <sound/simple_card.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
 #include <media/soc_camera.h>
 #include <media/i2c/tw9910.h>
 #include <media/i2c/mt9t112.h>
@@ -901,7 +901,7 @@ static struct platform_device irda_device = {
 };
 
 #include <media/i2c/ak881x.h>
-#include <media/sh_vou.h>
+#include <media/drv-intf/sh_vou.h>
 
 static struct ak881x_pdata ak881x_pdata = {
 	.flags = AK881X_IF_MODE_SLAVE,
diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index ec9357333878..6bd9230e64e3 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -29,7 +29,7 @@
 #include <linux/sh_intc.h>
 #include <media/i2c/rj54n1cb0c.h>
 #include <media/soc_camera.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
 #include <asm/suspend.h>
 #include <asm/clock.h>
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 7f91854dea15..8f237a5bd9aa 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -27,7 +27,7 @@
 #include <linux/videodev2.h>
 #include <linux/sh_intc.h>
 #include <video/sh_mobile_lcdc.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
 #include <media/i2c/ov772x.h>
 #include <media/soc_camera.h>
 #include <media/i2c/tw9910.h>
diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
index 4ecedcc2473c..e0e1df136642 100644
--- a/arch/sh/boards/mach-se/7724/setup.c
+++ b/arch/sh/boards/mach-se/7724/setup.c
@@ -30,7 +30,7 @@
 #include <linux/sh_intc.h>
 #include <linux/videodev2.h>
 #include <video/sh_mobile_lcdc.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
 #include <sound/sh_fsi.h>
 #include <sound/simple_card.h>
 #include <asm/io.h>
@@ -535,7 +535,7 @@ static struct platform_device irda_device = {
 };
 
 #include <media/i2c/ak881x.h>
-#include <media/sh_vou.h>
+#include <media/drv-intf/sh_vou.h>
 
 static struct ak881x_pdata ak881x_pdata = {
 	.flags = AK881X_IF_MODE_SLAVE,
diff --git a/drivers/media/common/cx2341x.c b/drivers/media/common/cx2341x.c
index c07b9db51b05..5e4afa0131e6 100644
--- a/drivers/media/common/cx2341x.c
+++ b/drivers/media/common/cx2341x.c
@@ -27,7 +27,7 @@
 #include <linux/videodev2.h>
 
 #include <media/tuner.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/v4l2-common.h>
 
 MODULE_DESCRIPTION("cx23415/6/8 driver");
diff --git a/drivers/media/common/saa7146/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
index 1ff9f5323bc3..9f7c5b0a6b45 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -20,7 +20,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <media/saa7146.h>
+#include <media/drv-intf/saa7146.h>
 #include <linux/module.h>
 
 static int saa7146_num;
diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index df1e8c975cd8..930d2c94d5d3 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -1,6 +1,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
 
 /****************************************************************************/
diff --git a/drivers/media/common/saa7146/saa7146_hlp.c b/drivers/media/common/saa7146/saa7146_hlp.c
index 3dc6a838ca6f..6ebcbc6450f5 100644
--- a/drivers/media/common/saa7146/saa7146_hlp.c
+++ b/drivers/media/common/saa7146/saa7146_hlp.c
@@ -2,7 +2,7 @@
 
 #include <linux/kernel.h>
 #include <linux/export.h>
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 
 static void calculate_output_format_register(struct saa7146_dev* saa, u32 palette, u32* clip_format)
 {
diff --git a/drivers/media/common/saa7146/saa7146_i2c.c b/drivers/media/common/saa7146/saa7146_i2c.c
index 22027198129d..239a2db35068 100644
--- a/drivers/media/common/saa7146/saa7146_i2c.c
+++ b/drivers/media/common/saa7146/saa7146_i2c.c
@@ -1,6 +1,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 
 static u32 saa7146_i2c_func(struct i2c_adapter *adapter)
 {
diff --git a/drivers/media/common/saa7146/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
index 2da995758778..49237518d65f 100644
--- a/drivers/media/common/saa7146/saa7146_vbi.c
+++ b/drivers/media/common/saa7146/saa7146_vbi.c
@@ -1,4 +1,4 @@
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 
 static int vbi_pixel_to_capture = 720 * 2;
 
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 30779498c173..d5837be3e8cf 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -1,6 +1,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ctrls.h>
 #include <linux/module.h>
diff --git a/drivers/media/i2c/cx25840/cx25840-audio.c b/drivers/media/i2c/cx25840/cx25840-audio.c
index 34b96c7cfd62..baf3d9c8710e 100644
--- a/drivers/media/i2c/cx25840/cx25840-audio.c
+++ b/drivers/media/i2c/cx25840/cx25840-audio.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <media/v4l2-common.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index fe6eb78b6914..181fdc14c6c6 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -45,7 +45,7 @@
 #include <linux/delay.h>
 #include <linux/math64.h>
 #include <media/v4l2-common.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/i2c/cx25840/cx25840-firmware.c b/drivers/media/i2c/cx25840/cx25840-firmware.c
index 9bbb31adc29d..37e052923a87 100644
--- a/drivers/media/i2c/cx25840/cx25840-firmware.c
+++ b/drivers/media/i2c/cx25840/cx25840-firmware.c
@@ -19,7 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/firmware.h>
 #include <media/v4l2-common.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 4cf8f18bf097..4b782012cadc 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/kfifo.h>
 #include <linux/module.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include <media/rc-core.h>
 
 #include "cx25840-core.h"
diff --git a/drivers/media/i2c/cx25840/cx25840-vbi.c b/drivers/media/i2c/cx25840/cx25840-vbi.c
index c39e91dc1137..04034c592603 100644
--- a/drivers/media/i2c/cx25840/cx25840-vbi.c
+++ b/drivers/media/i2c/cx25840/cx25840-vbi.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <media/v4l2-common.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/i2c/m5mols/m5mols_capture.c b/drivers/media/i2c/m5mols/m5mols_capture.c
index 95d9274a872c..a0cd6dc32eb0 100644
--- a/drivers/media/i2c/m5mols/m5mols_capture.c
+++ b/drivers/media/i2c/m5mols/m5mols_capture.c
@@ -26,7 +26,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/i2c/m5mols.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "m5mols.h"
 #include "m5mols_reg.h"
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index e48230bd514f..a84561d0d4a8 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -56,7 +56,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/i2c/tvaudio.h>
 #include "msp3400-driver.h"
 
diff --git a/drivers/media/i2c/msp3400-driver.h b/drivers/media/i2c/msp3400-driver.h
index fbe5e0715f93..6cae21366ed5 100644
--- a/drivers/media/i2c/msp3400-driver.h
+++ b/drivers/media/i2c/msp3400-driver.h
@@ -4,7 +4,7 @@
 #ifndef MSP3400_DRIVER_H
 #define MSP3400_DRIVER_H
 
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 
diff --git a/drivers/media/i2c/msp3400-kthreads.c b/drivers/media/i2c/msp3400-kthreads.c
index f8b51714f2f9..17120804fab7 100644
--- a/drivers/media/i2c/msp3400-kthreads.c
+++ b/drivers/media/i2c/msp3400-kthreads.c
@@ -26,7 +26,7 @@
 #include <linux/freezer.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <linux/kthread.h>
 #include <linux/suspend.h>
 #include "msp3400-driver.h"
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 4fbdd1e9f7ee..2e14e52ba2e0 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 48362e0be8b8..c2ba1fb3694d 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -17,7 +17,7 @@
 
 #include <media/i2c/mt9v022.h>
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 3f40606a60a7..9400e996087b 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -51,7 +51,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
 #include <media/i2c/tvaudio.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 
 #include <linux/dma-mapping.h>
 
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 28a02cd0fccd..b1e0023f923c 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -42,7 +42,7 @@
 #include <media/tveeprom.h>
 #include <media/rc-core.h>
 #include <media/i2c/ir-kbd-i2c.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 
 #include "bt848.h"
 #include "bttv.h"
diff --git a/drivers/media/pci/cx18/cx23418.h b/drivers/media/pci/cx18/cx23418.h
index 767a8d23e3f2..67ffe65b56a3 100644
--- a/drivers/media/pci/cx18/cx23418.h
+++ b/drivers/media/pci/cx18/cx23418.h
@@ -22,7 +22,7 @@
 #ifndef CX23418_H
 #define CX23418_H
 
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 
 #define MGR_CMD_MASK            		0x40000000
 /* The MSB of the command code indicates that this is the completion of a
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 88a3afb66d10..2fe3708d8654 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 
 #include "cx23885.h"
 #include "cx23885-ioctl.h"
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index f384f295676e..99ac2019e728 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include <linux/firmware.h>
 #include <misc/altera.h>
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 71a80e2b842c..63f302e06379 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -35,7 +35,7 @@
 #include "cx23885-ioctl.h"
 #include "tuner-xc2028.h"
 
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx23885 based TV cards");
 MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index c5ba0833f47a..f9eb57b186fa 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -30,7 +30,7 @@
 #include <media/rc-core.h>
 
 #include "cx23885-reg.h"
-#include "media/cx2341x.h"
+#include "media/drv-intf/cx2341x.h"
 
 #include <linux/mutex.h>
 
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 8b889135be8a..27ffb24d73bb 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -36,7 +36,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 
 #include "cx88.h"
 
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index d81b26ee89df..78f817ee7e41 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -30,7 +30,7 @@
 #include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/videobuf2-dma-sg.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/videobuf2-dvb.h>
 #include <media/i2c/ir-kbd-i2c.h>
 #include <media/i2c/wm8775.h>
diff --git a/drivers/media/pci/ivtv/ivtv-cards.c b/drivers/media/pci/ivtv/ivtv-cards.c
index 9eb964c9f593..410d97bdf541 100644
--- a/drivers/media/pci/ivtv/ivtv-cards.c
+++ b/drivers/media/pci/ivtv/ivtv-cards.c
@@ -22,11 +22,11 @@
 #include "ivtv-cards.h"
 #include "ivtv-i2c.h"
 
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/i2c/m52790.h>
 #include <media/i2c/wm8775.h>
 #include <media/i2c/cs53l32a.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include <media/i2c/upd64031a.h>
 
 #define MSP_TUNER  MSP_INPUT(MSP_IN_SCART1, MSP_IN_TUNER1, \
diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index e004f56267a6..6c08dae67a73 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -64,7 +64,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
 #include <media/tuner.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/i2c/ir-kbd-i2c.h>
 
 #include <linux/ivtv.h>
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index 1a41ba5c7d30..bccbf2d18e30 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -63,7 +63,7 @@
 #include "ivtv-cards.h"
 #include "ivtv-gpio.h"
 #include "ivtv-i2c.h"
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 /* i2c implementation for cx23415/6 chip, ivtv project.
  * Author: Kevin Thayer (nufan_wfk at yahoo.com)
diff --git a/drivers/media/pci/ivtv/ivtv-routing.c b/drivers/media/pci/ivtv/ivtv-routing.c
index 9a07808b61f0..0c168f238904 100644
--- a/drivers/media/pci/ivtv/ivtv-routing.c
+++ b/drivers/media/pci/ivtv/ivtv-routing.c
@@ -24,7 +24,7 @@
 #include "ivtv-gpio.h"
 #include "ivtv-routing.h"
 
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/i2c/m52790.h>
 #include <media/i2c/upd64031a.h>
 #include <media/i2c/upd64083.h>
diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index 03cbcd2095c6..c889ec9f8a5a 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -25,7 +25,7 @@
 
 #define DEBUG_VARIABLE debug
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
 
 static int debug;
diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
index 15f0d66ff78a..c306a92e8909 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -25,7 +25,7 @@
 
 #define DEBUG_VARIABLE debug
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
 
 static int debug;
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 04b66327e329..504d78807639 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -25,7 +25,7 @@
 
 #define DEBUG_VARIABLE debug
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <media/tuner.h>
 #include <media/v4l2-common.h>
 #include <media/i2c/saa7115.h>
diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
index 3a55927edb95..3707ccd02732 100644
--- a/drivers/media/pci/ttpci/av7110.h
+++ b/drivers/media/pci/ttpci/av7110.h
@@ -32,7 +32,7 @@
 #include "stv0297.h"
 #include "l64781.h"
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 
 
 #define ANALOG_TUNER_VES1820 1
diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index 3e469d4e0c87..f1f7360c01ba 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -46,7 +46,7 @@
 #include "tda1004x.h"
 #include "tua6100.h"
 #include "dvb-pll.h"
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/media/pci/ttpci/budget.h b/drivers/media/pci/ttpci/budget.h
index 1ccbe1a49a4b..655eef5236ca 100644
--- a/drivers/media/pci/ttpci/budget.h
+++ b/drivers/media/pci/ttpci/budget.h
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 
-#include <media/saa7146.h>
+#include <media/drv-intf/saa7146.h>
 
 extern int budget_debug;
 
diff --git a/drivers/media/platform/exynos4-is/common.c b/drivers/media/platform/exynos4-is/common.c
index 0eb34ecb8ee4..b6716c57b5db 100644
--- a/drivers/media/platform/exynos4-is/common.c
+++ b/drivers/media/platform/exynos4-is/common.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/module.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 #include "common.h"
 
 /* Called with the media graph mutex held or entity->stream_count > 0. */
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index d336fa2916df..6b7435453d2a 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -27,7 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-mediabus.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #define dbg(fmt, args...) \
 	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 6e6648446f00..f88a36908489 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "common.h"
 #include "media-dev.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index c2d25df85db9..e0686b5f1bf8 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -24,7 +24,7 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 extern int fimc_isp_debug;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index 0477716a20db..f0acc550d065 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -12,7 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "fimc-lite-reg.h"
 #include "fimc-lite.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 60660c3a5de0..6f76afd909c4 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "common.h"
 #include "fimc-core.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index b302305dedbe..11690d563e06 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -23,7 +23,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #define FIMC_LITE_DRV_NAME	"exynos-fimc-lite"
 #define FLITE_CLK_NAME		"flite"
diff --git a/drivers/media/platform/exynos4-is/fimc-reg.c b/drivers/media/platform/exynos4-is/fimc-reg.c
index df0cbcb69b6b..0806724553a2 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -13,7 +13,7 @@
 #include <linux/io.h>
 #include <linux/regmap.h>
 
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 #include "media-dev.h"
 
 #include "fimc-reg.h"
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a4cbff..9481ce3201a2 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-of.h>
 #include <media/media-device.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "media-dev.h"
 #include "fimc-core.h"
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 03214541f149..93a96126929b 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -19,7 +19,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "fimc-core.h"
 #include "fimc-lite.h"
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 4b85105dc159..ff5dabf24694 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 #include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index adaf1969ef63..57cbc3d9725d 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -26,7 +26,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
 #include <media/videobuf2-v4l2.h>
-#include <media/s3c_camif.h>
+#include <media/drv-intf/s3c_camif.h>
 
 #define S3C_CAMIF_DRIVER_NAME	"s3c-camif"
 #define CAMIF_REQ_BUFS_MIN	3
diff --git a/drivers/media/platform/s3c-camif/camif-regs.h b/drivers/media/platform/s3c-camif/camif-regs.h
index af2d472ea1dd..5ad36c1c2a5d 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.h
+++ b/drivers/media/platform/s3c-camif/camif-regs.h
@@ -13,7 +13,7 @@
 #define CAMIF_REGS_H_
 
 #include "camif-core.h"
-#include <media/s3c_camif.h>
+#include <media/drv-intf/s3c_camif.h>
 
 /*
  * The id argument indicates the processing path:
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 2231f8922df3..544e2b5a2ec3 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -22,7 +22,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/sh_vou.h>
+#include <media/drv-intf/sh_vou.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 454f68f0cdad..b24183ccebfe 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-of.h>
 #include <media/videobuf2-dma-contig.h>
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 1f28d21a3c9a..55437ec3a3e2 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -35,7 +35,7 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 
 #include <linux/videodev2.h>
 
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 49c3a257a916..3e67b9517a5a 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -23,7 +23,7 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 
 #include <linux/platform_data/camera-mx3.h>
 #include <linux/platform_data/dma-imx.h>
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index ba8dcd11ae0e..faebcab728fc 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -30,7 +30,7 @@
 
 #include <media/omap1_camera.h>
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/videobuf-dma-contig.h>
 #include <media/videobuf-dma-sg.h>
 
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index fcb942de0c7f..34762a82ebd2 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -33,7 +33,7 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-of.h>
 
 #include <linux/videodev2.h>
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index efe57b23fac1..32aa64c3fc7e 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -28,7 +28,7 @@
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 67a669d826b8..ad21307878cf 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -40,11 +40,11 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/soc_camera.h>
-#include <media/sh_mobile_ceu.h>
-#include <media/sh_mobile_csi2.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_csi2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-mediabus.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 
 #include "soc_scale_crop.h"
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 12d3626ecf22..09b18365a4b1 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -18,10 +18,10 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/sh_mobile_ceu.h>
-#include <media/sh_mobile_csi2.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_csi2.h>
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index dc98122e78dc..a339f0141aff 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -30,7 +30,7 @@
 #include <linux/vmalloc.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index 1dbcd426683c..e3e665e1c503 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -13,7 +13,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 
 static const struct soc_mbus_lookup mbus_fmt[] = {
 {
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 5236035f0f2a..41c16520a367 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -42,7 +42,7 @@
 #include <linux/videodev2.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index b8d61cbc18cb..8e4f1d18c9b2 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -14,7 +14,7 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <linux/isa.h>
 #include <linux/pnp.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 
 MODULE_AUTHOR("Ondrej Zary");
 MODULE_DESCRIPTION("MediaForte SF16-FMR2 and SF16-FMD2 FM radio card driver");
diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 050b3bb96fec..409fac188d40 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -33,7 +33,7 @@
 #include <linux/usb.h>
 #include <linux/workqueue.h>
 #include <media/v4l2-device.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 
 #if defined(CONFIG_LEDS_CLASS) || \
     (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK_MODULE))
diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 9cbb8cdf0ac0..859f0c08ee05 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-device.h>
 
-#include <media/si476x.h>
+#include <media/drv-intf/si476x.h>
 #include <linux/mfd/si476x-core.h>
 
 #define FM_FREQ_RANGE_LOW   64000000
diff --git a/drivers/media/radio/tea575x.c b/drivers/media/radio/tea575x.c
index 43d1ea53cb66..3e08475af579 100644
--- a/drivers/media/radio/tea575x.c
+++ b/drivers/media/radio/tea575x.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("Routines for control of TEA5757/5759 Philips AM/FM radio tuner chips");
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 47a98a2014a5..f59a6f18f458 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -37,7 +37,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/tuner.h>
 
 #define CX231xx_FIRM_IMAGE_SIZE 376836
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 4a117a58c39a..be018fc089de 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -30,7 +30,7 @@
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
 
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include "dvb-usb-ids.h"
 #include "xc5000.h"
 #include "tda18271.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index a08014d20a5c..15bb573b78ac 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -32,7 +32,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/tuner.h>
 
 #include "cx231xx-vbi.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index d0d8f08e37c8..246fb2bff114 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -36,7 +36,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/tuner.h>
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index e34eb1bfb567..ec6d3f5bc36d 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -30,7 +30,7 @@
 #include <linux/mutex.h>
 #include <linux/usb.h>
 
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index f9c1c8f31e24..5718c4f7517a 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -30,7 +30,7 @@
 #include <linux/i2c.h>
 #include <linux/usb.h>
 #include <media/tuner.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/i2c/saa7115.h>
 #include <media/i2c/tvp5150.h>
 #include <media/i2c/tvaudio.h>
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6a3cf342e087..bba205246b22 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -43,7 +43,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-clk.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/tuner.h>
 
 #define DRIVER_AUTHOR "Ludovico Cavedon <cavedon@sssup.it>, " \
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-audio.c b/drivers/media/usb/pvrusb2/pvrusb2-audio.c
index 45276c628482..5f953d837bf1 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-audio.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-audio.c
@@ -23,7 +23,7 @@
 #include "pvrusb2-hdw-internal.h"
 #include "pvrusb2-debug.h"
 #include <linux/videodev2.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/v4l2-common.h>
 
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
index 1a81aa70509b..7d675fae1846 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
@@ -32,7 +32,7 @@
 
 #include "pvrusb2-hdw-internal.h"
 #include "pvrusb2-debug.h"
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/errno.h>
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
index c940a12bb0ed..60141b16d731 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
@@ -39,7 +39,7 @@
 #include "pvrusb2-hdw.h"
 #include "pvrusb2-io.h"
 #include <media/v4l2-device.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/i2c/ir-kbd-i2c.h>
 #include "pvrusb2-devattr.h"
 
diff --git a/include/media/cx2341x.h b/include/media/drv-intf/cx2341x.h
similarity index 100%
rename from include/media/cx2341x.h
rename to include/media/drv-intf/cx2341x.h
diff --git a/include/media/cx25840.h b/include/media/drv-intf/cx25840.h
similarity index 100%
rename from include/media/cx25840.h
rename to include/media/drv-intf/cx25840.h
diff --git a/include/media/exynos-fimc.h b/include/media/drv-intf/exynos-fimc.h
similarity index 100%
rename from include/media/exynos-fimc.h
rename to include/media/drv-intf/exynos-fimc.h
diff --git a/include/media/msp3400.h b/include/media/drv-intf/msp3400.h
similarity index 99%
rename from include/media/msp3400.h
rename to include/media/drv-intf/msp3400.h
index 90cf22ada8b4..1e6e80213a77 100644
--- a/include/media/msp3400.h
+++ b/include/media/drv-intf/msp3400.h
@@ -223,4 +223,3 @@
  */
 
 #endif /* MSP3400_H */
-
diff --git a/include/media/s3c_camif.h b/include/media/drv-intf/s3c_camif.h
similarity index 100%
rename from include/media/s3c_camif.h
rename to include/media/drv-intf/s3c_camif.h
diff --git a/include/media/saa7146.h b/include/media/drv-intf/saa7146.h
similarity index 100%
rename from include/media/saa7146.h
rename to include/media/drv-intf/saa7146.h
diff --git a/include/media/saa7146_vv.h b/include/media/drv-intf/saa7146_vv.h
similarity index 99%
rename from include/media/saa7146_vv.h
rename to include/media/drv-intf/saa7146_vv.h
index 92766f77a5de..0da6ccc0615b 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/drv-intf/saa7146_vv.h
@@ -4,7 +4,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
-#include <media/saa7146.h>
+#include <media/drv-intf/saa7146.h>
 #include <media/videobuf-dma-sg.h>
 
 #define MAX_SAA7146_CAPTURE_BUFFERS	32	/* arbitrary */
diff --git a/include/media/sh_mobile_ceu.h b/include/media/drv-intf/sh_mobile_ceu.h
similarity index 100%
rename from include/media/sh_mobile_ceu.h
rename to include/media/drv-intf/sh_mobile_ceu.h
diff --git a/include/media/sh_mobile_csi2.h b/include/media/drv-intf/sh_mobile_csi2.h
similarity index 100%
rename from include/media/sh_mobile_csi2.h
rename to include/media/drv-intf/sh_mobile_csi2.h
diff --git a/include/media/sh_vou.h b/include/media/drv-intf/sh_vou.h
similarity index 100%
rename from include/media/sh_vou.h
rename to include/media/drv-intf/sh_vou.h
diff --git a/include/media/si476x.h b/include/media/drv-intf/si476x.h
similarity index 94%
rename from include/media/si476x.h
rename to include/media/drv-intf/si476x.h
index e02e241e2d22..ad87fa8483b2 100644
--- a/include/media/si476x.h
+++ b/include/media/drv-intf/si476x.h
@@ -1,5 +1,5 @@
 /*
- * include/media/si476x.h -- Common definitions for si476x driver
+ * include/media/drv-intf/si476x.h -- Common definitions for si476x driver
  *
  * Copyright (C) 2012 Innovative Converged Devices(ICD)
  * Copyright (C) 2013 Andrey Smirnov
diff --git a/include/media/soc_mediabus.h b/include/media/drv-intf/soc_mediabus.h
similarity index 100%
rename from include/media/soc_mediabus.h
rename to include/media/drv-intf/soc_mediabus.h
diff --git a/include/media/tea575x.h b/include/media/drv-intf/tea575x.h
similarity index 100%
rename from include/media/tea575x.h
rename to include/media/drv-intf/tea575x.h
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 1bdce501ad6b..2d225bcdb831 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -158,8 +158,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_S2255_BASE		(V4L2_CID_USER_BASE + 0x1030)
 
-/* The base for the si476x driver controls. See include/media/si476x.h for the list
- * of controls. Total of 16 controls is reserved for this driver */
+/*
+ * The base for the si476x driver controls. See include/media/drv-intf/si476x.h
+ * for the list of controls. Total of 16 controls is reserved for this driver
+ */
 #define V4L2_CID_USER_SI476X_BASE		(V4L2_CID_USER_BASE + 0x1040)
 
 /* The base for the TI VPE driver controls. Total of 16 controls is reserved for
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index e0d9363dc7fd..cb38cd1c5fc4 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -113,7 +113,7 @@
 #include <sound/initval.h>
 
 #ifdef CONFIG_SND_ES1968_RADIO
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 #endif
 
 #define CARD_NAME "ESS Maestro1/2"
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 1fdd92b6f18f..5144a7fcb5aa 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -30,7 +30,7 @@
 #include <sound/initval.h>
 
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 #endif
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
-- 
2.5.0
