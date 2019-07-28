From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v4 1/3] fs: Reserve flag for casefolding
Date: Sun, 28 Jul 2019 08:36:11 +0800
Message-ID: <056a12d4-d787-9a3d-9ad4-4d1136b2a197@kernel.org>
References: <20190723230529.251659-1-drosen@google.com>
 <20190723230529.251659-2-drosen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190723230529.251659-2-drosen@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Rosenberg <drosen@google.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Jonathan Corbet <corbet@lwn.net>, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com
List-Id: linux-api@vger.kernel.org

On 2019-7-24 7:05, Daniel Rosenberg via Linux-f2fs-devel wrote:
> In preparation for including the casefold feature within f2fs, elevate
> the EXT4_CASEFOLD_FL flag to FS_CASEFOLD_FL.
> 
> Signed-off-by: Daniel Rosenberg <drosen@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
