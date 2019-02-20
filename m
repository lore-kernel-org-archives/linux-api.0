From: Christian Brauner <christian@brauner.io>
Subject: Re: [RFC PATCH 00/27] Containers and using authenticated filesystems
Date: Wed, 20 Feb 2019 15:18:37 +0100
Message-ID: <20190220141715.ukjo5d4ctepahl43@brauner.io>
References: <155024683432.21651.14153938339749694146.stgit@warthog.procyon.org.uk>
 <8736ojybw7.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8736ojybw7.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org, sfrench@samba.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-fsdevel@vger.kernel.org, trond.myklebust@hammerspace.com
List-Id: linux-api@vger.kernel.org

On Tue, Feb 19, 2019 at 10:35:20AM -0600, Eric W. Biederman wrote:
> 
> So you missed the main mailing lists for discussion of this kind of
> thing, and the maintainer.  So I have reservations about the quality of
> your due diligence already.
> 
> Looking at your description you are introducing a container id.
> You don't descibe which namespace your contianer id lives in.
> Without the container id living in a container this breaks
> nested containers and process migration aka CRIU.
> 
> So based on the your description.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> 
> 
> David Howells <dhowells@redhat.com> writes:
> 
> > Here's a collection of patches that containerises the kernel keys and makes
> > it possible to separate keys by namespace.  This can be extended to any
> > filesystem that uses request_key() to obtain the pertinent authentication
> > token on entry to VFS or socket methods.

/me puts on kernel hat:
I'm not neccessarily opposed to making containers kernel objects even
though I have been for quite a while (for brevity I'll use "kcontainers"
for this). But I think the approach taken here is a little misguided.
This patchsets pushes the argument that kcontainers are needed because
of keyrings and authenticated filesystems and is designed around this
use-case. Imho, that is bound to fall short of requirements and
use-cases that have been piling up over the years.
If we want to make kcontainers a thing we need to have a separate
discussion and a separate patchset that is *solely* concerned with
creating a kcontainer api. And frankly, that is likely going to take a
long time.
At this point containers have become a real "thing" on Linux - like it
or not. So justifying it to making them in-kernel citizens doesn't need
the detour over keyrings or something else. We should just discuss
whether we think that the benefits of kcontainers (e.g. security)
outweight the costs (e.g. maintenance).

/me puts on runtime maintainer hat:
One thing that is true is that userspace containers (let's call them
"ucontainers") as implemented by runtimes today will not go away. We
have been living with this ad-hoc concept and it's various
implementations on upstream Linux at least since 2008. And kernels
without kcontainers will be with us until the end of (Linux)time
probably. So anyone who thinks that kcontainers will replace ucontainers
and that'll be it will be thoroughly disappointed in the end.
It is also very likely that not all use-cases we can currently cover
with ucontainers can be covered by kcontainers. Now that might be ok but
if we ever introduce kcontainers through a proper kernel api we will end
up maintaining ucontainers and kcontainers simultaneously. That's a
burden we shouldn't underestimate.
