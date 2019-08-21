From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v4 3/3] f2fs: Support case-insensitive file
 name lookups
Date: Wed, 21 Aug 2019 21:15:08 +0800
Message-ID: <354102fb-e076-78d4-174d-5a193cae70f0@kernel.org>
References: <20190723230529.251659-1-drosen@google.com>
 <20190723230529.251659-4-drosen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190723230529.251659-4-drosen@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Rosenberg <drosen@google.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Jonathan Corbet <corbet@lwn.net>, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com
List-Id: linux-api@vger.kernel.org

On 2019-7-24 7:05, Daniel Rosenberg via Linux-f2fs-devel wrote:
> +static int f2fs_d_compare(const struct dentry *dentry, unsigned int len,
> + const char *str, const struct qstr *name)
> +{
> +	struct qstr qstr = {.name = str, .len = len };
> +
> +	if (!IS_CASEFOLDED(dentry->d_parent->d_inode)) {
> +		if (len != name->len)
> +			return -1;
> +		return memcmp(str, name, len);

66883da1eee8 ("ext4: fix dcache lookup of !casefolded directories")

memcmp(str, name->name, len);
