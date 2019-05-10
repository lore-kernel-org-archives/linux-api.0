From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 3/3] initramfs: introduce do_readxattrs()
Date: Fri, 10 May 2019 23:33:40 +0200
Message-ID: <20190510213340.GE253532@google.com>
References: <20190509112420.15671-1-roberto.sassu@huawei.com>
 <20190509112420.15671-4-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190509112420.15671-4-roberto.sassu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com
List-Id: linux-api@vger.kernel.org

On Thu, May 09, 2019 at 01:24:20PM +0200, Roberto Sassu wrote:
> This patch adds support for an alternative method to add xattrs to files in
> the rootfs filesystem. Instead of extracting them directly from the ram
> disk image, they are extracted from a regular file called .xattr-list, that
> can be added by any ram disk generator available today.
[...]
> +struct path_hdr {
> +	char p_size[10]; /* total size including p_size field */
> +	char p_data[];  /* <path>\0<xattrs> */
> +};
> +
> +static int __init do_readxattrs(void)
> +{
> +	struct path_hdr hdr;
> +	char str[sizeof(hdr.p_size) + 1];
> +	unsigned long file_entry_size;
> +	size_t size, name_buf_size, total_size;
> +	struct kstat st;
> +	int ret, fd;
> +
> +	ret = vfs_lstat(XATTR_LIST_FILENAME, &st);
> +	if (ret < 0)
> +		return ret;
> +
> +	total_size = st.size;
> +
> +	fd = ksys_open(XATTR_LIST_FILENAME, O_RDONLY, 0);
> +	if (fd < 0)
> +		return fd;
> +
> +	while (total_size) {
> +		size = ksys_read(fd, (char *)&hdr, sizeof(hdr));
[...]
> +	ksys_close(fd);
> +
> +	if (ret < 0)
> +		error("Unable to parse xattrs");
> +
> +	return ret;
> +}

Please use something like filp_open()+kernel_read()+fput() instead of
ksys_open()+ksys_read()+ksys_close(). I understand that some of the init
code needs to use the syscall wrappers because no equivalent VFS
functions are available, but please use the VFS functions when that's
easy to do.
