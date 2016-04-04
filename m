From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/8] lib/uuid: introduce few more generic helpers for
 UUID
Date: Mon, 4 Apr 2016 16:40:29 -0700
Message-ID: <20160404164029.9c72a93cb29d619766fbb2d2@linux-foundation.org>
References: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1459776610-68469-4-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459776610-68469-4-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>, Matt Fleming <matt@codeblueprint.co.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon,  4 Apr 2016 16:30:05 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> There are new helpers in this patch:
> 
> uuid_is_valid		checks if a UUID is valid
> uuid_be_to_bin		converts from string to binary (big endian)
> uuid_le_to_bin		converts from string to binary (little endian)
	> 
> They will be used in future, i.e. in the following patches in the series.
> 
> This also moves indices arrays to lib/uuid.c to be shared accross modules.
> 
> ...
>
> --- a/include/linux/uuid.h
> +++ b/include/linux/uuid.h

Nit:

> +/**
> +  * uuid_is_valid - checks if UUID string valid
> +  * @uuid:	UUID string to check
> +  *
> +  * Description:
> +  * It checks if the UUID string is following the format:
> +  *	xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
> +  * where x is a hex digit.
> +  *
> +  * Return: 0 on success, %-EINVAL otherwise.
> +  */
> +int uuid_is_valid(const char *uuid)
> +{
> +	unsigned int i;
> +
> +	if (strnlen(uuid, UUID_STRING_LEN) < UUID_STRING_LEN)
> +		return -EINVAL;
> +
> +	for (i = 0; i < UUID_STRING_LEN; i++) {
> +		if (i == 8 || i == 13 || i == 18 || i == 23) {
> +			if (uuid[i] != '-')
> +				return -EINVAL;
> +		} else if (!isxdigit(uuid[i])) {
> +			return -EINVAL;
> +		}
> +	}

Could add

	if (uuid[i])
		return -EINVAL;

here and lose the additional pass across the input (strlen).

> +	return 0;
> +}
>
> ...
>
