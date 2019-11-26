From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH v3 03/12] fs: add RWF_ENCODED for reading/writing
 compressed data
Date: Tue, 26 Nov 2019 09:36:07 -0800
Message-ID: <20191126173607.GA657777@vader>
References: <cover.1574273658.git.osandov@fb.com>
 <07f9cc1969052e94818fa50019e7589d206d1d18.1574273658.git.osandov@fb.com>
 <d1886c1f-f19e-f3a7-32d6-8803a71a510c@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d1886c1f-f19e-f3a7-32d6-8803a71a510c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Amir Goldstein <amir73il@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Tue, Nov 26, 2019 at 03:53:02PM +0200, Nikolay Borisov wrote:
> 
> 
> On 20.11.19 г. 20:24 ч., Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> 
> <snip>
> 
> >  
> > +enum {
> > +	ENCODED_IOV_COMPRESSION_NONE,
> > +#define ENCODED_IOV_COMPRESSION_NONE ENCODED_IOV_COMPRESSION_NONE
> > +	ENCODED_IOV_COMPRESSION_ZLIB,
> > +#define ENCODED_IOV_COMPRESSION_ZLIB ENCODED_IOV_COMPRESSION_ZLIB
> > +	ENCODED_IOV_COMPRESSION_LZO,
> > +#define ENCODED_IOV_COMPRESSION_LZO ENCODED_IOV_COMPRESSION_LZO
> > +	ENCODED_IOV_COMPRESSION_ZSTD,
> > +#define ENCODED_IOV_COMPRESSION_ZSTD ENCODED_IOV_COMPRESSION_ZSTD
> > +	ENCODED_IOV_COMPRESSION_TYPES = ENCODED_IOV_COMPRESSION_ZSTD,
> 
> This looks very dodgy, what am I missing?

This is a somewhat common trick so that enum values can be checked for
with ifdef/ifndef. See include/uapi/linux.in.h, for example.
