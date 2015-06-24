From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v6 7/9] nvmem: qfprom: Add bindings for qfprom
Date: Wed, 24 Jun 2015 10:49:16 +0100
Message-ID: <558A7D1C.8050708@linaro.org>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <1435014570-26434-1-git-send-email-srinivas.kandagatla@linaro.org> <55892602.2030809@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <55892602.2030809@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Rajendra Nayak <rnayak@codeaurora.org>, linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org



On 23/06/15 10:25, Rajendra Nayak wrote:
> []..
>
>> +Example:
>> +
>> +    qfprom: qfprom@00700000 {
>> +        compatible     = "qcom,qfprom";
>> +        reg        = <0x00700000 0x8000>;
>> +        ...
>> +        /* Data cells */
>> +        tsens_calibration: calib@404 {
>> +            reg = <0x4404 0x10>;
>> +        };
>> +    };
>> +
>> +
>> += Data consumers =
>> +Are device nodes which consume nvmem data cells.
>> +
>> +For example:
>> +
>> +    tsens {
>> +        ...
>> +        nvmem-cell = <&tsens_calibration>;
>
> Shouldn't this be nvmem-cells instead?
>
You are correct, Will fix it in next version.

--srini
>> +        nvmem-cell-names = "calibration";
>> +    };
>>
