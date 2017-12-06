From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Wed, 6 Dec 2017 07:28:22 +0100
Message-ID: <20171206062822.GB20995@kroah.com>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <20171128133217.GA29995@kroah.com>
 <CA+M3ks51HFZr62FKsuc6k84ei=scbQDBjtgQy25Mi3RjXhYcyw@mail.gmail.com>
 <20171202155317.GB5311@kroah.com>
 <65ef83b2-db3e-eaf6-129f-40e156400624@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <65ef83b2-db3e-eaf6-129f-40e156400624-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Riley Andrews <riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, driverdevel <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 05, 2017 at 03:01:42PM -0800, Laura Abbott wrote:
> On 12/02/2017 07:53 AM, Greg KH wrote:
> > > This is one of the item in the TODO list before been able to unstage ION
> > > which is my real need.
> > Why does it matter where in the tree this code is?  Don't go adding new
> > things to it that are not needed.  Who needs this?  What userspace code
> > wants this type of multiple ion devices?
> > 
> 
> Requirements came in from several places to split /dev/ion -> /dev/ion0
> and /dev/ion1 so that security policy (i.e. selinux) could be used to
> protect access to certain heaps. I wanted the ABI to be settled before
> trying to move out of staging, hence the line in the TODO list about
> doing the split.

Ok, but we should have some way of testing it works, right?  :)
