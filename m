From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] iio: hmc5843: Fix comment style warnings
Date: Tue, 9 Feb 2016 22:17:01 +0000
Message-ID: <56BA655D.4000407@kernel.org>
References: <1454883711-15489-1-git-send-email-cristina.moraru09@gmail.com>
 <1454883711-15489-5-git-send-email-cristina.moraru09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454883711-15489-5-git-send-email-cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cristina Moraru <cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, knaack.h-Mmb7MZpHnFY@public.gmane.org, lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, marek-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org, sdliyong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tolga.ceylan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, octavia.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/02/16 22:21, Cristina Moraru wrote:
> Fix comment style warnings in order to comply with Coding Style
> standard provided by Documentation/CodingStyle.
> 
> This patch solves following issue found with checkpatch:
> WARNING: Block comments use a trailing */ on a separate line
> 
> Signed-off-by: Cristina Moraru <cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
I've applied this, but with a few additions... see inline.
> ---
>  drivers/staging/iio/magnetometer/hmc5843.h     | 4 ++--
>  drivers/staging/iio/magnetometer/hmc5843_i2c.c | 2 +-
>  drivers/staging/iio/magnetometer/hmc5843_spi.c | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/iio/magnetometer/hmc5843.h b/drivers/staging/iio/magnetometer/hmc5843.h
> index 06f35d3..cb284cf 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843.h
> +++ b/drivers/staging/iio/magnetometer/hmc5843.h
> @@ -8,7 +8,7 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   *
Dropped the unwanted empty comment line as it doesn't add anything and we
might as well clean it up whilst here.
> - * */
> + */
>  
>  #ifndef HMC5843_CORE_H
>  #define HMC5843_CORE_H
> @@ -38,7 +38,7 @@ enum hmc5843_ids {
>   * @regmap:		hardware access register maps
>   * @variant:		describe chip variants
>   * @buffer:		3x 16-bit channels + padding + 64-bit timestamp
> - **/
> + */
>  struct hmc5843_data {
>  	struct device *dev;
>  	struct mutex lock;
> diff --git a/drivers/staging/iio/magnetometer/hmc5843_i2c.c b/drivers/staging/iio/magnetometer/hmc5843_i2c.c
> index 3e06ceb..6f7b8fb 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843_i2c.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843_i2c.c
> @@ -8,7 +8,7 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   *
snap
> - * */
> + */
>  
>  #include <linux/module.h>
>  #include <linux/i2c.h>
> diff --git a/drivers/staging/iio/magnetometer/hmc5843_spi.c b/drivers/staging/iio/magnetometer/hmc5843_spi.c
> index 1549192..85adcdd 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843_spi.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843_spi.c
> @@ -7,7 +7,7 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   *
snap.
> - * */
> + */
>  
>  #include <linux/module.h>
>  #include <linux/spi/spi.h>
> 
