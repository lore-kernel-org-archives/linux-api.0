From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Mon, 13 May 2019 14:36:24 -0400
Message-ID: <1557772584.4969.62.camel@linux.ibm.com>
References: <dca50ee1-62d8-2256-6fdb-9a786e6cea5a@landley.net>
         <20190512194322.GA71658@rani.riverdale.lan>
         <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
         <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
         <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
         <20190513172007.GA69717@rani.riverdale.lan>
         <20190513175250.GC69717@rani.riverdale.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190513175250.GC69717@rani.riverdale.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Sankar <niveditas98@gmail.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>, Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org


> > How does this work today then? Is it actually the case that initramfs
> > just cannot be used on an IMA-enabled system, or it can but it leaves
> > the initramfs unverified and we're trying to fix that? I had assumed the
> > latter.
> Oooh, it's done not by starting IMA appraisal later, but by loading a
> default policy to ignore initramfs?

Right, when rootfs is a tmpfs filesystem, it supports xattrs, allowing
for finer grained policies to be defined.  This patch set would allow
a builtin IMA appraise policy to be defined which includes tmpfs.

Mimi
