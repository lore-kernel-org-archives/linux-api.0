From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Thu, 16 May 2019 09:31:32 -0400
Message-ID: <1558013492.4581.97.camel@linux.ibm.com>
References: <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
         <f7bc547c-61f4-1a17-735c-7e8df97d7965@huawei.com>
         <CALCETrV3b205L38xqPr6QqwGn6-vxQdPoJGUygJJpgM-JqqXfQ@mail.gmail.com>
         <1557861511.3378.19.camel@HansenPartnership.com>
         <4da3dbda-bb76-5d71-d5c5-c03d98350ab0@landley.net>
         <1557878052.2873.6.camel@HansenPartnership.com>
         <20190515005221.GB88615@rani.riverdale.lan>
         <a138af12-d983-453e-f0b2-661a80b7e837@huawei.com>
         <20190515160834.GA81614@rani.riverdale.lan>
         <ce65240a-4df6-8ebc-8360-c01451e724f0@huawei.com>
         <20190516052934.GA68777@rani.riverdale.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516052934.GA68777@rani.riverdale.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Sankar <nivedita@alum.mit.edu>, Roberto Sassu <roberto.sassu@huawei.com>, Mehmet Kayaalp <mkayaalp@linux.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Rob Landley <rob@landley.net>, Andy Lutomirski <luto@kernel.org>, Arvind Sankar <niveditas98@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, initramfs@vger.kernel.org, Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>
List-Id: linux-api@vger.kernel.org

On Thu, 2019-05-16 at 01:29 -0400, Arvind Sankar wrote:

> I think that's a separate issue. If you want to allow people to be able
> to put files onto the system that will be IMA verified, they need to
> have some way to locally sign them whether it's inside an initramfs or
> on a real root filesystem.

Anyone building their own kernel can build their own key into the
kernel image.  Another option is to build the kernel with  
CONFIG_SYSTEM_EXTRA_CERTIFICATE enabled, allowing an additional
certificate to be inserted into the kernel image post build.  The
additional certificate will be loaded onto the builtin kernel keyring.
 Certificates signed with the private key can then be added to the IMA
keyring.  By modifying the kernel image, the kernel image obviously
needs to be resigned.  Additional patches "Certificate insertion
support for x86 bzImages" were posted, but have not been upstreamed.

This patch set adds the security xattrs needed by IMA.

Mimi


 
