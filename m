From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/2] Input: Document and check on implicitly defined
 FF_MAX_EFFECTS
Date: Wed, 14 Oct 2015 17:52:42 -0700
Message-ID: <20151015005242.GE3673@dtor-ws>
References: <1442510988-3164-1-git-send-email-elias.vds@gmail.com>
 <1442510988-3164-2-git-send-email-elias.vds@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-input-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442510988-3164-2-git-send-email-elias.vds@gmail.com>
Sender: linux-input-owner@vger.kernel.org
To: Elias Vanderstuyft <elias.vds@gmail.com>
Cc: linux-input@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 17, 2015 at 07:29:47PM +0200, Elias Vanderstuyft wrote:
> There is an undocumented upper bound for the total number of ff effects:
>     FF_GAIN (= 96).
> This can be found as follows:
> - user: write(EV_FF, effect_id, iterations)
>     calls kernel: ff->playback(effect_id, ...): starts effect "effect_id"
> - user: write(EV_FF, FF_GAIN, gain)
>     calls kernel: ff->set_gain(gain, ...): sets gain
> 
> A collision occurs when effect_id equals FF_GAIN.
> According to input_ff_event(),
> FF_GAIN is the smallest value where a collision occurs.
> Therefore the greatest safe value for effect_id is FF_GAIN - 1,
> and thus the total number of effects should never exceed FF_GAIN.
> 
> Define FF_MAX_EFFECTS as FF_GAIN and check on this limit in ff-core.
> 
> Signed-off-by: Elias Vanderstuyft <elias.vds@gmail.com>

Applied, thank you.

> ---
>  drivers/input/ff-core.c    | 5 +++++
>  include/uapi/linux/input.h | 8 ++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
> index c642082..0bf7008 100644
> --- a/drivers/input/ff-core.c
> +++ b/drivers/input/ff-core.c
> @@ -318,6 +318,11 @@ int input_ff_create(struct input_dev *dev, unsigned int max_effects)
>  		return -EINVAL;
>  	}
>  
> +	if (max_effects > FF_MAX_EFFECTS) {
> +		dev_err(&dev->dev, "cannot allocate more than FF_MAX_EFFECTS effects\n");
> +		return -EINVAL;
> +	}
> +
>  	ff_dev_size = sizeof(struct ff_device) +
>  				max_effects * sizeof(struct file *);
>  	if (ff_dev_size < max_effects) /* overflow */
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index 63915a7..42d7933 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -1200,6 +1200,14 @@ struct ff_effect {
>  #define FF_GAIN		0x60
>  #define FF_AUTOCENTER	0x61
>  
> +/*
> + * ff->playback(effect_id = FF_GAIN) is the first effect_id to
> + * cause a collision with another ff method, in this case ff->set_gain().
> + * Therefore the greatest safe value for effect_id is FF_GAIN - 1,
> + * and thus the total number of effects should never exceed FF_GAIN.
> + */
> +#define FF_MAX_EFFECTS	FF_GAIN
> +
>  #define FF_MAX		0x7f
>  #define FF_CNT		(FF_MAX+1)
>  
> -- 
> 1.9.3
> 

-- 
Dmitry
