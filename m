From: Bjorn Andersson <bjorn@kryo.se>
Subject: Re: [PATCH v3 8/9] eeprom: qfprom: Add bindings for qfprom
Date: Wed, 25 Mar 2015 01:28:33 +0100
Message-ID: <CAJAp7OgTaJ0FTD1pEgxOxt24_1fAmdK+7v4VuvDojHkoKkJHqg@mail.gmail.com>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1427236268-18882-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1427236268-18882-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@codeaurora.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 11:31 PM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> This patch adds bindings for qfprom found in QCOM SOCs. QFPROM driver
> is based on simple eeprom framework.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  .../devicetree/bindings/eeprom/qfprom.txt          | 23 ++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/eeprom/qfprom.txt
>
> diff --git a/Documentation/devicetree/bindings/eeprom/qfprom.txt b/Documentation/devicetree/bindings/eeprom/qfprom.txt
> new file mode 100644
> index 0000000..d5baed6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/eeprom/qfprom.txt
> @@ -0,0 +1,23 @@
> += Qualcomm QFPROM device tree bindings =
> +
> +This binding is intended to represent QFPROM which is found in most QCOM SOCs.
> +
> +Required properties:
> +- compatible: should be "qcom,qfprom"
> +- reg: Should contain registers location and length
> +
> += Data cells =
> +Are child nodes of qfprom, bindings of which as described in
> +bindings/eeprom/eeprom.txt
> +
> +Example:
> +
> +       qfprom: qfprom@00700000 {
> +               compatible      = "qcom,qfprom";
> +               reg             = <0x00700000 0x1000>;

The qfprom block starts at 0x700000 and is 0x8000 long.

The registers at the beginning of this block are raw R/W fuse bits and
should not be read directly. Instead there is an ecc corrected shadow
copy of these registers at 0x4000.

> +               ...
> +               /* Data cells */
> +               tsens_calibration: calib@404 {
> +                       reg = <0x404 0x10>;
> +               };
> +       };

Regards,
Bjorn
