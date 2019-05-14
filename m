From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Tue, 14 May 2019 11:57:40 -0400
Message-ID: <20190514155739.GA70223@rani.riverdale.lan>
References: <dca50ee1-62d8-2256-6fdb-9a786e6cea5a@landley.net>
 <20190512194322.GA71658@rani.riverdale.lan>
 <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
 <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
 <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
 <49965ffd-dd57-ffe5-4a2f-73cdfb387848@landley.net>
 <de91ef53-6bb3-b937-8773-5f6b34e1acb7@huawei.com>
 <20190514152704.GB37109@rani.riverdale.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190514152704.GB37109@rani.riverdale.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Rob Landley <rob@landley.net>, Arvind Sankar <niveditas98@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 14, 2019 at 11:27:04AM -0400, Arvind Sankar wrote:
> It's also much easier to change/customize it for the end
> system's requirements rather than setting the process in stone by
> putting it inside the kernel.

As an example, if you allow unverified external initramfs, it seems to
me that it can try to play games that wouldn't be prevented by the
in-kernel code: setup /dev in a weird way to try to trick /init, or more
easily, replace /init by /bin/sh so you get a shell prompt while only
the initramfs is loaded. It's easy to imagine that a system would want
to lock itself down to prevent abuses like this.
So you might already want an embedded initramfs that can be trusted and
that can't be overwritten by an external one even outside the
security.ima stuff.
