From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V31 25/25] debugfs: Disable open() when kernel is locked
 down
Date: Thu, 28 Mar 2019 03:53:32 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1903280353120.31119@namei.org>
References: <20190326182742.16950-1-matthewgarrett@google.com> <20190326182742.16950-26-matthewgarrett@google.com> <CALCETrXDF2c2-gnOyNTnEn-uPAZp0AaSB_PB8e2y8jf7zo=Cyg@mail.gmail.com> <20190327003057.GA27311@kroah.com> <CALCETrVDDf4dj3Md1Nxc5P_NCToXGnAbEO3bGfwgKSfeVmU4Kw@mail.gmail.com>
 <20190327050615.GA548@kroah.com> <16124107-70D3-4CA0-9766-36FC6DC10128@amacapital.net> <20190327053342.GA17484@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327053342.GA17484@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Matthew Garrett <matthewgarrett@google.com>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, 27 Mar 2019, Greg KH wrote:

> Personally, I think these are all just "confidentiality" type things,
> but who really knows given the wild-west nature of debugfs (which is as
> designed).  And given that I think this patch series just crazy anyway,
> I really don't care :)

Why do you think it's crazy?

-- 
James Morris
<jmorris@namei.org>
