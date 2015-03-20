From: Martin Kepplinger <martink@posteo.de>
Subject: Re: [PATCH v4] add support for Freescale's MMA8653FC 10 bit accelerometer
Date: Fri, 20 Mar 2015 14:43:03 +0100
Message-ID: <550C23E7.500@posteo.de>
References: <1426850431-31550-1-git-send-email-martink@posteo.de> <550C0502.7090507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <550C0502.7090507@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Varka Bhadram <varkabhadram@gmail.com>, mark.rutland@arm.com, robh+dt@kernel.org, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, dmitry.torokhov@gmail.com, alexander.stein@systec-electronic.com
Cc: hadess@hadess.net, akpm@linux-foundation.org, gregkh@linuxfoundation.org, linux-api@vger.kernel.org, devicetree@vger.kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Kepplinger <martin.kepplinger@theobroma-systems.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>
List-Id: linux-api@vger.kernel.org

Am 2015-03-20 um 12:31 schrieb Varka Bhadram:
> On 03/20/2015 04:50 PM, Martin Kepplinger wrote:
>> From: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
>>
( ...)
>> +    return 0;
>> +
>> + err_free_irq:
>> +    if (mma->irq)
>> +        free_irq(mma->irq, mma);
>> + err_free_mem:
>> +    kfree(mma);
> 
> If we use devm_* API's above steps are not required
> 
>> + err_out:
>> +    return err;
>> +}
>> +
>> +static int mma8653fc_remove(struct i2c_client *client)
>> +{
>> +    struct mma8653fc *mma = i2c_get_clientdata(client);
>> +
>> +    free_irq(mma->irq, mma);
>> +    dev_dbg(&client->dev, "unregistered accelerometer\n");
>> +    kfree(mma);
> 
> same as above..
> 

thanks!
