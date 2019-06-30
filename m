From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v4 3/3] gen_init_cpio: add support for file metadata
Date: Sun, 30 Jun 2019 11:27:36 -0400
Message-ID: <1561908456.3985.23.camel@linux.ibm.com>
References: <20190523121803.21638-1-roberto.sassu@huawei.com>
         <20190523121803.21638-4-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523121803.21638-4-roberto.sassu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>, viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, bug-cpio@gnu.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org

On Thu, 2019-05-23 at 14:18 +0200, Roberto Sassu wrote:

> diff --git a/usr/Kconfig b/usr/Kconfig
> index 43658b8a975e..8d9f54a16440 100644
> --- a/usr/Kconfig
> +++ b/usr/Kconfig
> @@ -233,3 +233,11 @@ config INITRAMFS_COMPRESSION
>  	default ".lzma" if RD_LZMA
>  	default ".bz2"  if RD_BZIP2
>  	default ""
> +
> +config INITRAMFS_FILE_METADATA
> +	string "File metadata type"
> +	default ""
> +	help
> +	  Specify xattr to include xattrs in the image.
> +
> +	  If you are not sure, leave it blank.
> 	fi

Instead of having to specify the metdata type, let's make this a
choice.

Mimi
