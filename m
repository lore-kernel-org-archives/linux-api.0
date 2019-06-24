From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH V34 10/29] hibernate: Disable when the kernel is locked
 down
Date: Mon, 24 Jun 2019 15:21:23 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1906241520500.27227@cbobk.fhfr.pm>
References: <20190622000358.19895-1-matthewgarrett@google.com> <20190622000358.19895-11-matthewgarrett@google.com> <20190622175208.GB30317@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190622175208.GB30317@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, rjw@rjwysocki.net, Joey Lee <JLee@suse.com>, linux-pm@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, 22 Jun 2019, Pavel Machek wrote:

> > There is currently no way to verify the resume image when returning
> > from hibernate.  This might compromise the signed modules trust model,
> > so until we can work with signed hibernate images we disable it when the
> > kernel is locked down.
> 
> I keep getting these...
> 
> IIRC suse has patches to verify the images.

Yeah, Joey Lee is taking care of those. CCing.

-- 
Jiri Kosina
SUSE Labs
