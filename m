From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 02/10] [media] v4l: Update subdev-formats doc with new
 MEDIA_BUS_FMT values
Date: Fri,  7 Nov 2014 15:07:41 +0100
Message-ID: <1415369269-5064-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Cc: devel@driverdev.osuosl.org, Boris Brezillon <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

In order to have subsytem agnostic media bus format definitions we've
moved media bus definition to include/uapi/linux/media-bus-format.h and
prefixed them with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Update the v4l documentation accordingly.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 308 ++++++++++-----------
 1 file changed, 154 insertions(+), 154 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index b2d5a03..18730b9 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -86,7 +86,7 @@
       green and 5-bit blue values padded on the high bit, transferred as 2 8-bit
       samples per pixel with the most significant bits (padding, red and half of
       the green value) transferred first will be named
-      <constant>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</constant>.
+      <constant>MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE</constant>.
       </para>
 
       <para>The following tables list existing packed RGB formats.</para>
@@ -176,8 +176,8 @@
 	    </row>
 	  </thead>
 	  <tbody valign="top">
-	    <row id="V4L2-MBUS-FMT-RGB444-2X8-PADHI-BE">
-	      <entry>V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE</entry>
+	    <row id="MEDIA-BUS-FMT-RGB444-2X8-PADHI-BE">
+	      <entry>MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE</entry>
 	      <entry>0x1001</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -204,8 +204,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-RGB444-2X8-PADHI-LE">
-	      <entry>V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE</entry>
+	    <row id="MEDIA-BUS-FMT-RGB444-2X8-PADHI-LE">
+	      <entry>MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE</entry>
 	      <entry>0x1002</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -232,8 +232,8 @@
 	      <entry>r<subscript>1</subscript></entry>
 	      <entry>r<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-RGB555-2X8-PADHI-BE">
-	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</entry>
+	    <row id="MEDIA-BUS-FMT-RGB555-2X8-PADHI-BE">
+	      <entry>MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE</entry>
 	      <entry>0x1003</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -260,8 +260,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-RGB555-2X8-PADHI-LE">
-	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE</entry>
+	    <row id="MEDIA-BUS-FMT-RGB555-2X8-PADHI-LE">
+	      <entry>MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE</entry>
 	      <entry>0x1004</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -288,8 +288,8 @@
 	      <entry>g<subscript>4</subscript></entry>
 	      <entry>g<subscript>3</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-BGR565-2X8-BE">
-	      <entry>V4L2_MBUS_FMT_BGR565_2X8_BE</entry>
+	    <row id="MEDIA-BUS-FMT-BGR565-2X8-BE">
+	      <entry>MEDIA_BUS_FMT_BGR565_2X8_BE</entry>
 	      <entry>0x1005</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -316,8 +316,8 @@
 	      <entry>r<subscript>1</subscript></entry>
 	      <entry>r<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-BGR565-2X8-LE">
-	      <entry>V4L2_MBUS_FMT_BGR565_2X8_LE</entry>
+	    <row id="MEDIA-BUS-FMT-BGR565-2X8-LE">
+	      <entry>MEDIA_BUS_FMT_BGR565_2X8_LE</entry>
 	      <entry>0x1006</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -344,8 +344,8 @@
 	      <entry>g<subscript>4</subscript></entry>
 	      <entry>g<subscript>3</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-RGB565-2X8-BE">
-	      <entry>V4L2_MBUS_FMT_RGB565_2X8_BE</entry>
+	    <row id="MEDIA-BUS-FMT-RGB565-2X8-BE">
+	      <entry>MEDIA_BUS_FMT_RGB565_2X8_BE</entry>
 	      <entry>0x1007</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -372,8 +372,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-RGB565-2X8-LE">
-	      <entry>V4L2_MBUS_FMT_RGB565_2X8_LE</entry>
+	    <row id="MEDIA-BUS-FMT-RGB565-2X8-LE">
+	      <entry>MEDIA_BUS_FMT_RGB565_2X8_LE</entry>
 	      <entry>0x1008</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -400,8 +400,8 @@
 	      <entry>g<subscript>4</subscript></entry>
 	      <entry>g<subscript>3</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-RGB666-1X18">
-	      <entry>V4L2_MBUS_FMT_RGB666_1X18</entry>
+	    <row id="MEDIA-BUS-FMT-RGB666-1X18">
+	      <entry>MEDIA_BUS_FMT_RGB666_1X18</entry>
 	      <entry>0x1009</entry>
 	      <entry></entry>
 	      &dash-ent-14;
@@ -424,8 +424,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-RGB888-1X24">
-	      <entry>V4L2_MBUS_FMT_RGB888_1X24</entry>
+	    <row id="MEDIA-BUS-FMT-RGB888-1X24">
+	      <entry>MEDIA_BUS_FMT_RGB888_1X24</entry>
 	      <entry>0x100a</entry>
 	      <entry></entry>
 	      &dash-ent-8;
@@ -454,8 +454,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-RGB888-2X12-BE">
-	      <entry>V4L2_MBUS_FMT_RGB888_2X12_BE</entry>
+	    <row id="MEDIA-BUS-FMT-RGB888-2X12-BE">
+	      <entry>MEDIA_BUS_FMT_RGB888_2X12_BE</entry>
 	      <entry>0x100b</entry>
 	      <entry></entry>
 	      &dash-ent-20;
@@ -490,8 +490,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-RGB888-2X12-LE">
-	      <entry>V4L2_MBUS_FMT_RGB888_2X12_LE</entry>
+	    <row id="MEDIA-BUS-FMT-RGB888-2X12-LE">
+	      <entry>MEDIA_BUS_FMT_RGB888_2X12_LE</entry>
 	      <entry>0x100c</entry>
 	      <entry></entry>
 	      &dash-ent-20;
@@ -526,8 +526,8 @@
 	      <entry>g<subscript>5</subscript></entry>
 	      <entry>g<subscript>4</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-ARGB888-1X32">
-	      <entry>V4L2_MBUS_FMT_ARGB888_1X32</entry>
+	    <row id="MEDIA-BUS-FMT-ARGB888-1X32">
+	      <entry>MEDIA_BUS_FMT_ARGB888_1X32</entry>
 	      <entry>0x100d</entry>
 	      <entry></entry>
 	      <entry>a<subscript>7</subscript></entry>
@@ -600,7 +600,7 @@
       <para>For instance, a format with uncompressed 10-bit Bayer components
       arranged in a red, green, green, blue pattern transferred as 2 8-bit
       samples per pixel with the least significant bits transferred first will
-      be named <constant>V4L2_MBUS_FMT_SRGGB10_2X8_PADHI_LE</constant>.
+      be named <constant>MEDIA_BUS_FMT_SRGGB10_2X8_PADHI_LE</constant>.
       </para>
 
       <figure id="bayer-patterns">
@@ -663,8 +663,8 @@
 	    </row>
 	  </thead>
 	  <tbody valign="top">
-	    <row id="V4L2-MBUS-FMT-SBGGR8-1X8">
-	      <entry>V4L2_MBUS_FMT_SBGGR8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SBGGR8-1X8">
+	      <entry>MEDIA_BUS_FMT_SBGGR8_1X8</entry>
 	      <entry>0x3001</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -680,8 +680,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGBRG8-1X8">
-	      <entry>V4L2_MBUS_FMT_SGBRG8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SGBRG8-1X8">
+	      <entry>MEDIA_BUS_FMT_SGBRG8_1X8</entry>
 	      <entry>0x3013</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -697,8 +697,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGRBG8-1X8">
-	      <entry>V4L2_MBUS_FMT_SGRBG8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SGRBG8-1X8">
+	      <entry>MEDIA_BUS_FMT_SGRBG8_1X8</entry>
 	      <entry>0x3002</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -714,8 +714,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SRGGB8-1X8">
-	      <entry>V4L2_MBUS_FMT_SRGGB8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SRGGB8-1X8">
+	      <entry>MEDIA_BUS_FMT_SRGGB8_1X8</entry>
 	      <entry>0x3014</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -731,8 +731,8 @@
 	      <entry>r<subscript>1</subscript></entry>
 	      <entry>r<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SBGGR10-ALAW8-1X8">
-	      <entry>V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SBGGR10-ALAW8-1X8">
+	      <entry>MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8</entry>
 	      <entry>0x3015</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -748,8 +748,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGBRG10-ALAW8-1X8">
-	      <entry>V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SGBRG10-ALAW8-1X8">
+	      <entry>MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8</entry>
 	      <entry>0x3016</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -765,8 +765,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGRBG10-ALAW8-1X8">
-	      <entry>V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SGRBG10-ALAW8-1X8">
+	      <entry>MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8</entry>
 	      <entry>0x3017</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -782,8 +782,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SRGGB10-ALAW8-1X8">
-	      <entry>V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SRGGB10-ALAW8-1X8">
+	      <entry>MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8</entry>
 	      <entry>0x3018</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -799,8 +799,8 @@
 	      <entry>r<subscript>1</subscript></entry>
 	      <entry>r<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SBGGR10-DPCM8-1X8">
-	      <entry>V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SBGGR10-DPCM8-1X8">
+	      <entry>MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8</entry>
 	      <entry>0x300b</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -816,8 +816,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGBRG10-DPCM8-1X8">
-	      <entry>V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SGBRG10-DPCM8-1X8">
+	      <entry>MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8</entry>
 	      <entry>0x300c</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -833,8 +833,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGRBG10-DPCM8-1X8">
-	      <entry>V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SGRBG10-DPCM8-1X8">
+	      <entry>MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8</entry>
 	      <entry>0x3009</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -850,8 +850,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SRGGB10-DPCM8-1X8">
-	      <entry>V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-SRGGB10-DPCM8-1X8">
+	      <entry>MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8</entry>
 	      <entry>0x300d</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -867,8 +867,8 @@
 	      <entry>r<subscript>1</subscript></entry>
 	      <entry>r<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADHI-BE">
-	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE</entry>
+	    <row id="MEDIA-BUS-FMT-SBGGR10-2X8-PADHI-BE">
+	      <entry>MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE</entry>
 	      <entry>0x3003</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -901,8 +901,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADHI-LE">
-	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE</entry>
+	    <row id="MEDIA-BUS-FMT-SBGGR10-2X8-PADHI-LE">
+	      <entry>MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE</entry>
 	      <entry>0x3004</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -935,8 +935,8 @@
 	      <entry>b<subscript>9</subscript></entry>
 	      <entry>b<subscript>8</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADLO-BE">
-	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE</entry>
+	    <row id="MEDIA-BUS-FMT-SBGGR10-2X8-PADLO-BE">
+	      <entry>MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE</entry>
 	      <entry>0x3005</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -969,8 +969,8 @@
 	      <entry>0</entry>
 	      <entry>0</entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADLO-LE">
-	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE</entry>
+	    <row id="MEDIA-BUS-FMT-SBGGR10-2X8-PADLO-LE">
+	      <entry>MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE</entry>
 	      <entry>0x3006</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -1003,8 +1003,8 @@
 	      <entry>b<subscript>3</subscript></entry>
 	      <entry>b<subscript>2</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SBGGR10-1X10">
-	      <entry>V4L2_MBUS_FMT_SBGGR10_1X10</entry>
+	    <row id="MEDIA-BUS-FMT-SBGGR10-1X10">
+	      <entry>MEDIA_BUS_FMT_SBGGR10_1X10</entry>
 	      <entry>0x3007</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -1020,8 +1020,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGBRG10-1X10">
-	      <entry>V4L2_MBUS_FMT_SGBRG10_1X10</entry>
+	    <row id="MEDIA-BUS-FMT-SGBRG10-1X10">
+	      <entry>MEDIA_BUS_FMT_SGBRG10_1X10</entry>
 	      <entry>0x300e</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -1037,8 +1037,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGRBG10-1X10">
-	      <entry>V4L2_MBUS_FMT_SGRBG10_1X10</entry>
+	    <row id="MEDIA-BUS-FMT-SGRBG10-1X10">
+	      <entry>MEDIA_BUS_FMT_SGRBG10_1X10</entry>
 	      <entry>0x300a</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -1054,8 +1054,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SRGGB10-1X10">
-	      <entry>V4L2_MBUS_FMT_SRGGB10_1X10</entry>
+	    <row id="MEDIA-BUS-FMT-SRGGB10-1X10">
+	      <entry>MEDIA_BUS_FMT_SRGGB10_1X10</entry>
 	      <entry>0x300f</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -1071,8 +1071,8 @@
 	      <entry>r<subscript>1</subscript></entry>
 	      <entry>r<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SBGGR12-1X12">
-	      <entry>V4L2_MBUS_FMT_SBGGR12_1X12</entry>
+	    <row id="MEDIA-BUS-FMT-SBGGR12-1X12">
+	      <entry>MEDIA_BUS_FMT_SBGGR12_1X12</entry>
 	      <entry>0x3008</entry>
 	      <entry></entry>
 	      <entry>b<subscript>11</subscript></entry>
@@ -1088,8 +1088,8 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGBRG12-1X12">
-	      <entry>V4L2_MBUS_FMT_SGBRG12_1X12</entry>
+	    <row id="MEDIA-BUS-FMT-SGBRG12-1X12">
+	      <entry>MEDIA_BUS_FMT_SGBRG12_1X12</entry>
 	      <entry>0x3010</entry>
 	      <entry></entry>
 	      <entry>g<subscript>11</subscript></entry>
@@ -1105,8 +1105,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SGRBG12-1X12">
-	      <entry>V4L2_MBUS_FMT_SGRBG12_1X12</entry>
+	    <row id="MEDIA-BUS-FMT-SGRBG12-1X12">
+	      <entry>MEDIA_BUS_FMT_SGRBG12_1X12</entry>
 	      <entry>0x3011</entry>
 	      <entry></entry>
 	      <entry>g<subscript>11</subscript></entry>
@@ -1122,8 +1122,8 @@
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-SRGGB12-1X12">
-	      <entry>V4L2_MBUS_FMT_SRGGB12_1X12</entry>
+	    <row id="MEDIA-BUS-FMT-SRGGB12-1X12">
+	      <entry>MEDIA_BUS_FMT_SRGGB12_1X12</entry>
 	      <entry>0x3012</entry>
 	      <entry></entry>
 	      <entry>r<subscript>11</subscript></entry>
@@ -1175,7 +1175,7 @@
 
       <para>For instance, a format where pixels are encoded as 8-bit YUV values
       downsampled to 4:2:2 and transferred as 2 8-bit bus samples per pixel in the
-      U, Y, V, Y order will be named <constant>V4L2_MBUS_FMT_UYVY8_2X8</constant>.
+      U, Y, V, Y order will be named <constant>MEDIA_BUS_FMT_UYVY8_2X8</constant>.
       </para>
 
 	<para><xref linkend="v4l2-mbus-pixelcode-yuv8"/> lists existing packed YUV
@@ -1280,8 +1280,8 @@
 	    </row>
 	  </thead>
 	  <tbody valign="top">
-	    <row id="V4L2-MBUS-FMT-Y8-1X8">
-	      <entry>V4L2_MBUS_FMT_Y8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-Y8-1X8">
+	      <entry>MEDIA_BUS_FMT_Y8_1X8</entry>
 	      <entry>0x2001</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1294,8 +1294,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-UV8-1X8">
-	      <entry>V4L2_MBUS_FMT_UV8_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-UV8-1X8">
+	      <entry>MEDIA_BUS_FMT_UV8_1X8</entry>
 	      <entry>0x2015</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1322,8 +1322,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-UYVY8-1_5X8">
-	      <entry>V4L2_MBUS_FMT_UYVY8_1_5X8</entry>
+	    <row id="MEDIA-BUS-FMT-UYVY8-1_5X8">
+	      <entry>MEDIA_BUS_FMT_UYVY8_1_5X8</entry>
 	      <entry>0x2002</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1406,8 +1406,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-VYUY8-1_5X8">
-	      <entry>V4L2_MBUS_FMT_VYUY8_1_5X8</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY8-1_5X8">
+	      <entry>MEDIA_BUS_FMT_VYUY8_1_5X8</entry>
 	      <entry>0x2003</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1490,8 +1490,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YUYV8-1_5X8">
-	      <entry>V4L2_MBUS_FMT_YUYV8_1_5X8</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV8-1_5X8">
+	      <entry>MEDIA_BUS_FMT_YUYV8_1_5X8</entry>
 	      <entry>0x2004</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1574,8 +1574,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YVYU8-1_5X8">
-	      <entry>V4L2_MBUS_FMT_YVYU8_1_5X8</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU8-1_5X8">
+	      <entry>MEDIA_BUS_FMT_YVYU8_1_5X8</entry>
 	      <entry>0x2005</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1658,8 +1658,8 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-UYVY8-2X8">
-	      <entry>V4L2_MBUS_FMT_UYVY8_2X8</entry>
+	    <row id="MEDIA-BUS-FMT-UYVY8-2X8">
+	      <entry>MEDIA_BUS_FMT_UYVY8_2X8</entry>
 	      <entry>0x2006</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1714,8 +1714,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-VYUY8-2X8">
-	      <entry>V4L2_MBUS_FMT_VYUY8_2X8</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY8-2X8">
+	      <entry>MEDIA_BUS_FMT_VYUY8_2X8</entry>
 	      <entry>0x2007</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1770,8 +1770,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YUYV8-2X8">
-	      <entry>V4L2_MBUS_FMT_YUYV8_2X8</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV8-2X8">
+	      <entry>MEDIA_BUS_FMT_YUYV8_2X8</entry>
 	      <entry>0x2008</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1826,8 +1826,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YVYU8-2X8">
-	      <entry>V4L2_MBUS_FMT_YVYU8_2X8</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU8-2X8">
+	      <entry>MEDIA_BUS_FMT_YVYU8_2X8</entry>
 	      <entry>0x2009</entry>
 	      <entry></entry>
 	      &dash-ent-24;
@@ -1882,8 +1882,8 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-Y10-1X10">
-	      <entry>V4L2_MBUS_FMT_Y10_1X10</entry>
+	    <row id="MEDIA-BUS-FMT-Y10-1X10">
+	      <entry>MEDIA_BUS_FMT_Y10_1X10</entry>
 	      <entry>0x200a</entry>
 	      <entry></entry>
 	      &dash-ent-22;
@@ -1898,8 +1898,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-UYVY10-2X10">
-	      <entry>V4L2_MBUS_FMT_UYVY10_2X10</entry>
+	    <row id="MEDIA-BUS-FMT-UYVY10-2X10">
+	      <entry>MEDIA_BUS_FMT_UYVY10_2X10</entry>
 	      <entry>0x2018</entry>
 	      <entry></entry>
 	      &dash-ent-22;
@@ -1962,8 +1962,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-VYUY10-2X10">
-	      <entry>V4L2_MBUS_FMT_VYUY10_2X10</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY10-2X10">
+	      <entry>MEDIA_BUS_FMT_VYUY10_2X10</entry>
 	      <entry>0x2019</entry>
 	      <entry></entry>
 	      &dash-ent-22;
@@ -2026,8 +2026,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YUYV10-2X10">
-	      <entry>V4L2_MBUS_FMT_YUYV10_2X10</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV10-2X10">
+	      <entry>MEDIA_BUS_FMT_YUYV10_2X10</entry>
 	      <entry>0x200b</entry>
 	      <entry></entry>
 	      &dash-ent-22;
@@ -2090,8 +2090,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YVYU10-2X10">
-	      <entry>V4L2_MBUS_FMT_YVYU10_2X10</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU10-2X10">
+	      <entry>MEDIA_BUS_FMT_YVYU10_2X10</entry>
 	      <entry>0x200c</entry>
 	      <entry></entry>
 	      &dash-ent-22;
@@ -2154,8 +2154,8 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-Y12-1X12">
-	      <entry>V4L2_MBUS_FMT_Y12_1X12</entry>
+	    <row id="MEDIA-BUS-FMT-Y12-1X12">
+	      <entry>MEDIA_BUS_FMT_Y12_1X12</entry>
 	      <entry>0x2013</entry>
 	      <entry></entry>
 	      &dash-ent-20;
@@ -2172,8 +2172,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-UYVY8-1X16">
-	      <entry>V4L2_MBUS_FMT_UYVY8_1X16</entry>
+	    <row id="MEDIA-BUS-FMT-UYVY8-1X16">
+	      <entry>MEDIA_BUS_FMT_UYVY8_1X16</entry>
 	      <entry>0x200f</entry>
 	      <entry></entry>
 	      &dash-ent-16;
@@ -2216,8 +2216,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-VYUY8-1X16">
-	      <entry>V4L2_MBUS_FMT_VYUY8_1X16</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY8-1X16">
+	      <entry>MEDIA_BUS_FMT_VYUY8_1X16</entry>
 	      <entry>0x2010</entry>
 	      <entry></entry>
 	      &dash-ent-16;
@@ -2260,8 +2260,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YUYV8-1X16">
-	      <entry>V4L2_MBUS_FMT_YUYV8_1X16</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV8-1X16">
+	      <entry>MEDIA_BUS_FMT_YUYV8_1X16</entry>
 	      <entry>0x2011</entry>
 	      <entry></entry>
 	      &dash-ent-16;
@@ -2304,8 +2304,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YVYU8-1X16">
-	      <entry>V4L2_MBUS_FMT_YVYU8_1X16</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU8-1X16">
+	      <entry>MEDIA_BUS_FMT_YVYU8_1X16</entry>
 	      <entry>0x2012</entry>
 	      <entry></entry>
 	      &dash-ent-16;
@@ -2348,8 +2348,8 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YDYUYDYV8-1X16">
-	      <entry>V4L2_MBUS_FMT_YDYUYDYV8_1X16</entry>
+	    <row id="MEDIA-BUS-FMT-YDYUYDYV8-1X16">
+	      <entry>MEDIA_BUS_FMT_YDYUYDYV8_1X16</entry>
 	      <entry>0x2014</entry>
 	      <entry></entry>
 	      &dash-ent-16;
@@ -2436,8 +2436,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-UYVY10-1X20">
-	      <entry>V4L2_MBUS_FMT_UYVY10_1X20</entry>
+	    <row id="MEDIA-BUS-FMT-UYVY10-1X20">
+	      <entry>MEDIA_BUS_FMT_UYVY10_1X20</entry>
 	      <entry>0x201a</entry>
 	      <entry></entry>
 	      &dash-ent-12;
@@ -2488,8 +2488,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-VYUY10-1X20">
-	      <entry>V4L2_MBUS_FMT_VYUY10_1X20</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY10-1X20">
+	      <entry>MEDIA_BUS_FMT_VYUY10_1X20</entry>
 	      <entry>0x201b</entry>
 	      <entry></entry>
 	      &dash-ent-12;
@@ -2540,8 +2540,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YUYV10-1X20">
-	      <entry>V4L2_MBUS_FMT_YUYV10_1X20</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV10-1X20">
+	      <entry>MEDIA_BUS_FMT_YUYV10_1X20</entry>
 	      <entry>0x200d</entry>
 	      <entry></entry>
 	      &dash-ent-12;
@@ -2592,8 +2592,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YVYU10-1X20">
-	      <entry>V4L2_MBUS_FMT_YVYU10_1X20</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU10-1X20">
+	      <entry>MEDIA_BUS_FMT_YVYU10_1X20</entry>
 	      <entry>0x200e</entry>
 	      <entry></entry>
 	      &dash-ent-12;
@@ -2644,8 +2644,8 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YUV10-1X30">
-	      <entry>V4L2_MBUS_FMT_YUV10_1X30</entry>
+	    <row id="MEDIA-BUS-FMT-YUV10-1X30">
+	      <entry>MEDIA_BUS_FMT_YUV10_1X30</entry>
 	      <entry>0x2016</entry>
 	      <entry></entry>
 	      <entry>-</entry>
@@ -2681,8 +2681,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-AYUV8-1X32">
-	      <entry>V4L2_MBUS_FMT_AYUV8_1X32</entry>
+	    <row id="MEDIA-BUS-FMT-AYUV8-1X32">
+	      <entry>MEDIA_BUS_FMT_AYUV8_1X32</entry>
 	      <entry>0x2017</entry>
 	      <entry></entry>
 	      <entry>a<subscript>7</subscript></entry>
@@ -2718,8 +2718,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-UYVY12-2X12">
-	      <entry>V4L2_MBUS_FMT_UYVY12_2X12</entry>
+	    <row id="MEDIA-BUS-FMT-UYVY12-2X12">
+	      <entry>MEDIA_BUS_FMT_UYVY12_2X12</entry>
 	      <entry>0x201c</entry>
 	      <entry></entry>
 	      &dash-ent-20;
@@ -2790,8 +2790,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-VYUY12-2X12">
-	      <entry>V4L2_MBUS_FMT_VYUY12_2X12</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY12-2X12">
+	      <entry>MEDIA_BUS_FMT_VYUY12_2X12</entry>
 	      <entry>0x201d</entry>
 	      <entry></entry>
 	      &dash-ent-20;
@@ -2862,8 +2862,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YUYV12-2X12">
-	      <entry>V4L2_MBUS_FMT_YUYV12_2X12</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV12-2X12">
+	      <entry>MEDIA_BUS_FMT_YUYV12_2X12</entry>
 	      <entry>0x201e</entry>
 	      <entry></entry>
 	      &dash-ent-20;
@@ -2934,8 +2934,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YVYU12-2X12">
-	      <entry>V4L2_MBUS_FMT_YVYU12_2X12</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU12-2X12">
+	      <entry>MEDIA_BUS_FMT_YVYU12_2X12</entry>
 	      <entry>0x201f</entry>
 	      <entry></entry>
 	      &dash-ent-20;
@@ -3006,8 +3006,8 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-UYVY12-1X24">
-	      <entry>V4L2_MBUS_FMT_UYVY12_1X24</entry>
+	    <row id="MEDIA-BUS-FMT-UYVY12-1X24">
+	      <entry>MEDIA_BUS_FMT_UYVY12_1X24</entry>
 	      <entry>0x2020</entry>
 	      <entry></entry>
 	      &dash-ent-8;
@@ -3066,8 +3066,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-VYUY12-1X24">
-	      <entry>V4L2_MBUS_FMT_VYUY12_1X24</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY12-1X24">
+	      <entry>MEDIA_BUS_FMT_VYUY12_1X24</entry>
 	      <entry>0x2021</entry>
 	      <entry></entry>
 	      &dash-ent-8;
@@ -3126,8 +3126,8 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YUYV12-1X24">
-	      <entry>V4L2_MBUS_FMT_YUYV12_1X24</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV12-1X24">
+	      <entry>MEDIA_BUS_FMT_YUYV12_1X24</entry>
 	      <entry>0x2022</entry>
 	      <entry></entry>
 	      &dash-ent-8;
@@ -3186,8 +3186,8 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="V4L2-MBUS-FMT-YVYU12-1X24">
-	      <entry>V4L2_MBUS_FMT_YVYU12_1X24</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU12-1X24">
+	      <entry>MEDIA_BUS_FMT_YVYU12_1X24</entry>
 	      <entry>0x2023</entry>
 	      <entry></entry>
 	      &dash-ent-8;
@@ -3366,8 +3366,8 @@
 	    </row>
 	  </thead>
 	  <tbody valign="top">
-	    <row id="V4L2-MBUS-FMT-AHSV8888-1X32">
-	      <entry>V4L2_MBUS_FMT_AHSV8888_1X32</entry>
+	    <row id="MEDIA-BUS-FMT-AHSV8888-1X32">
+	      <entry>MEDIA_BUS_FMT_AHSV8888_1X32</entry>
 	      <entry>0x6001</entry>
 	      <entry></entry>
 	      <entry>a<subscript>7</subscript></entry>
@@ -3422,7 +3422,7 @@
       </para>
 
       <para>For instance, for a JPEG baseline process and an 8-bit bus width
-        the format will be named <constant>V4L2_MBUS_FMT_JPEG_1X8</constant>.
+        the format will be named <constant>MEDIA_BUS_FMT_JPEG_1X8</constant>.
       </para>
 
       <para>The following table lists existing JPEG compressed formats.</para>
@@ -3441,8 +3441,8 @@
 	    </row>
 	  </thead>
 	  <tbody valign="top">
-	    <row id="V4L2-MBUS-FMT-JPEG-1X8">
-	      <entry>V4L2_MBUS_FMT_JPEG_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-JPEG-1X8">
+	      <entry>MEDIA_BUS_FMT_JPEG_1X8</entry>
 	      <entry>0x4001</entry>
 	      <entry>Besides of its usage for the parallel bus this format is
 		recommended for transmission of JPEG data over MIPI CSI bus
@@ -3484,8 +3484,8 @@ interface and may change in the future.</para>
 	    </row>
 	  </thead>
 	  <tbody valign="top">
-	    <row id="V4L2-MBUS-FMT-S5C-UYVY-JPEG-1X8">
-	      <entry>V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8</entry>
+	    <row id="MEDIA-BUS-FMT-S5C-UYVY-JPEG-1X8">
+	      <entry>MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8</entry>
 	      <entry>0x5001</entry>
 	      <entry>
 		Interleaved raw UYVY and JPEG image format with embedded
-- 
1.9.1
