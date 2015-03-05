From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 3/6] eeprom: Add bindings for simple eeprom framework
Date: Thu, 5 Mar 2015 14:11:26 -0600
Message-ID: <CAL_Jsq+wrZYn82otDfLsTVpgmhLFWtzRHQ4v+qn-Ks--ZpXR8Q@mail.gmail.com>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org> <1425548765-13019-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425548765-13019-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 5, 2015 at 3:46 AM, Srinivas Kandagatla
<srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This patch adds bindings for simple eeprom framework which allows eeprom
> consumers to talk to eeprom providers to get access to eeprom cell data.
>
> Signed-off-by: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> [Maxime Ripard: intial version of eeprom framework]
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  .../devicetree/bindings/eeprom/eeprom.txt          | 70 ++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/eeprom/eeprom.txt
>
> diff --git a/Documentation/devicetree/bindings/eeprom/eeprom.txt b/Documentation/devicetree/bindings/eeprom/eeprom.txt
> new file mode 100644
> index 0000000..dbfb95c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/eeprom/eeprom.txt
> @@ -0,0 +1,70 @@
> += EEPROM Data Device Tree Bindings =
> +
> +This binding is intended to represent the location of hardware
> +configuration data stored in EEPROMs.
> +
> +On a significant proportion of boards, the manufacturer has stored
> +some data on an EEPROM-like device, for the OS to be able to retrieve
> +these information and act upon it. Obviously, the OS has to know
> +about where to retrieve these data from, and where they are stored on
> +the storage device.
> +
> +This document is here to document this.
> +
> += Data providers =
> +Contains bindings specific to provider drivers and data cells as children
> +to this node.
> +
> += Data cells =
> +These are the child nodes of the provider which contain data cell
> +information like offset and size in eeprom provider.
> +
> +Required properties:
> +reg:   specifies the offset in byte within that storage device, and the length
> +       in bytes of the data we care about.
> +       There could be more then one offset-length pairs in this property.
> +
> +Optional properties:
> +As required by specific data parsers/interpreters.
> +
> +For example:
> +
> +       /* Provider */
> +       qfprom: qfprom@00700000 {
> +               compatible      = "qcom,qfprom";
> +               reg             = <0x00700000 0x1000>;
> +               ...
> +
> +               /* Data cells */
> +               tsens_calibration: calib@404 {
> +                       reg = <0x404 0x10>;
> +               };
> +
> +               serial_number: sn {
> +                       reg = <0x104 0x4>, <0x204 0x4>, <0x30c 0x4>;
> +
> +               };
> +               ...
> +       };
> +
> += Data consumers =
> +Are drivers which consume eeprom data cells.

s/drivers/device nodes/

> +
> +Required properties:
> +
> +eeproms: List of phandle and data cell the device might be interested in.
> +
> +Optional properties:
> +
> +eeprom-names: List of data cell name strings sorted in the same order
> +             as the resets property. Consumers drivers will use

resets?

> +             eeprom-names to differentiate between multiple cells,
> +             and hence being able to know what these cells are for.

Is this still needed? The sub-node name defines the name. Or you can
use reg-names with-in the sub-node.

Rob

> +
> +For example:
> +
> +       tsens {
> +               ...
> +               eeproms = <&tsens_calibration>;
> +               eeprom-names = "calibration";
> +       };
> --
> 1.9.1
>
