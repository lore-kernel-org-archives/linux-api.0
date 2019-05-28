From: Daniel Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
Date: Tue, 28 May 2019 17:53:55 -0400
Message-ID: <509ea6b0-1ac8-b809-98c2-37c34dd98ca3@redhat.com>
References: <cover.1554732921.git.rgb@redhat.com>
 <20190422113810.GA27747@hmswarspite.think-freely.org>
 <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
Reply-To: dwalsh@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, Mrunal Patel <mpatel@redhat.com>
List-Id: linux-api@vger.kernel.org

On 4/22/19 9:49 AM, Paul Moore wrote:
> On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>> On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
>>> Implement kernel audit container identifier.
>> I'm sorry, I've lost track of this, where have we landed on it? Are we good for
>> inclusion?
> I haven't finished going through this latest revision, but unless
> Richard made any significant changes outside of the feedback from the
> v5 patchset I'm guessing we are "close".
>
> Based on discussions Richard and I had some time ago, I have always
> envisioned the plan as being get the kernel patchset, tests, docs
> ready (which Richard has been doing) and then run the actual
> implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
> to make sure the actual implementation is sane from their perspective.
> They've already seen the design, so I'm not expecting any real
> surprises here, but sometimes opinions change when they have actual
> code in front of them to play with and review.
>
> Beyond that, while the cri-o/lxc/etc. folks are looking it over,
> whatever additional testing we can do would be a big win.  I'm
> thinking I'll pull it into a separate branch in the audit tree
> (audit/working-container ?) and include that in my secnext kernels
> that I build/test on a regular basis; this is also a handy way to keep
> it based against the current audit/next branch.  If any changes are
> needed Richard can either chose to base those changes on audit/next or
> the separate audit container ID branch; that's up to him.  I've done
> this with other big changes in other trees, e.g. SELinux, and it has
> worked well to get some extra testing in and keep the patchset "merge
> ready" while others outside the subsystem look things over.
>
Mrunal Patel (maintainer of CRI-O) and I have reviewed the API, and
believe this is something we can work on in the container runtimes team
to implement the container auditing code in CRI-O and Podman.
