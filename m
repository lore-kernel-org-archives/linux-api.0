From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [RFC PATCH v3 03/12] fs: add RWF_ENCODED for reading/writing
 compressed data
Date: Tue, 26 Nov 2019 15:53:02 +0200
Message-ID: <d1886c1f-f19e-f3a7-32d6-8803a71a510c@suse.com>
References: <cover.1574273658.git.osandov@fb.com>
 <07f9cc1969052e94818fa50019e7589d206d1d18.1574273658.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <07f9cc1969052e94818fa50019e7589d206d1d18.1574273658.git.osandov@fb.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Amir Goldstein <amir73il@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org



On 20.11.19 г. 20:24 ч., Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>

<snip>

>  
> +enum {
> +	ENCODED_IOV_COMPRESSION_NONE,
> +#define ENCODED_IOV_COMPRESSION_NONE ENCODED_IOV_COMPRESSION_NONE
> +	ENCODED_IOV_COMPRESSION_ZLIB,
> +#define ENCODED_IOV_COMPRESSION_ZLIB ENCODED_IOV_COMPRESSION_ZLIB
> +	ENCODED_IOV_COMPRESSION_LZO,
> +#define ENCODED_IOV_COMPRESSION_LZO ENCODED_IOV_COMPRESSION_LZO
> +	ENCODED_IOV_COMPRESSION_ZSTD,
> +#define ENCODED_IOV_COMPRESSION_ZSTD ENCODED_IOV_COMPRESSION_ZSTD
> +	ENCODED_IOV_COMPRESSION_TYPES = ENCODED_IOV_COMPRESSION_ZSTD,

This looks very dodgy, what am I missing?

<snip>
