From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 2/2] initramfs: introduce do_readxattrs()
Date: Fri, 17 May 2019 14:41:56 -0700
Message-ID: <69ef1f55-9fc1-7ee0-371f-3dbc77551dc0@zytor.com>
References: <20190517165519.11507-1-roberto.sassu@huawei.com>
 <20190517165519.11507-3-roberto.sassu@huawei.com>
 <CD9A4F89-7CA5-4329-A06A-F8DEB87905A5@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CD9A4F89-7CA5-4329-A06A-F8DEB87905A5@zytor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>, viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org

On 5/17/19 1:18 PM, hpa@zytor.com wrote:
> 
> Ok... I just realized this does not work for a modular initramfs, composed at load time from multiple files, which is a very real problem. Should be easy enough to deal with: instead of one large file, use one companion file per source file, perhaps something like filename..xattrs (suggesting double dots to make it less likely to conflict with a "real" file.) No leading dot, as it makes it more likely that archivers will sort them before the file proper.
> 
> A side benefit is that the format can be simpler as there is no need to encode the filename.
> 
> A technically cleaner solution still, but which would need archiver modifications, would be to encode the xattrs as an optionally nameless file (just an empty string) with a new file mode value, immediately following the original file. The advantage there is that the archiver itself could support xattrs and other extended metadata (which has been requested elsewhere); the disadvantage obviously is that that it requires new support in the archiver. However, at least it ought to be simpler since it is still a higher protocol level than the cpio archive itself.
> 
> There's already one special case in cpio, which is the "!!!TRAILER!!!" filename; although I don't think it is part of the formal spec, to the extent there is one, I would expect that in practice it is always encoded with a mode of 0, which incidentally could be used to unbreak the case where such a filename actually exists. So one way to support such extended metadata would be to set mode to 0 and use the filename to encode the type of metadata. I wonder how existing GNU or BSD cpio (the BSD one is better maintained these days) would deal with reading such a file; it would at least not be a regression if it just read it still, possibly with warnings. It could also be possible to use bits 17:16 in the mode, which are traditionally always zero (mode_t being 16 bits), but I believe are pres
 ent in most or all of the cpio formats for historical reasons. It might be accepted better by existing implementations to use one of these high bits combined with S_IFREG, I dont know.
> 

Correction: it's just !!!TRAILER!!!.

I tested with GNU cpio, BSD cpio, scpio and pax.

With a mode of 0:

	- GNU cpio errors, but extracts all the other files.
	- BSD cpio extracts them as regular files.
	- scpio and pax abort.

With a mode of 0x18000 (bit 16 + S_IFREG), all of them happily extracted
the data as regular files.

	-hpa
