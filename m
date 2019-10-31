From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm: Fix checking unmapped holes for mbind
Date: Wed, 30 Oct 2019 21:08:36 -0700
Message-ID: <20191030210836.a17c0649354b59961903d1a8@linux-foundation.org>
References: <201910291756045288126@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201910291756045288126@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Babka <vbabka@suse.cz>, Hocko <mhocko@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, API <linux-api@vger.kernel.org>, Dickins <hughd@google.com>, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

(cc linux-man@vger.kernel.org)

On Tue, 29 Oct 2019 17:56:06 +0800 "Li Xinhai" <lixinhai.lxh@gmail.com> wro=
te:

> queue_pages_range() will check for unmapped holes besides queue pages for
> migration. The rules for checking unmapped holes are:
> 1 Unmapped holes at any part of the specified range should be reported as
> =A0 EFAULT if mbind() for none MPOL_DEFAULT cases;
> 2 Unmapped holes at any part of the specified range should be ignored if
> =A0 mbind() for MPOL_DEFAULT case;
> Note that the second rule is the current implementation, but it seems
> conflicts the Linux API definition.

Can you quote the part of the API definition which you're looking at?

My mbind(2) manpage says

ERRORS
       EFAULT Part or all of the memory range specified by nodemask and max=
n-
              ode points outside your accessible address space.  Or, there =
was
              an unmapped hole in the specified memory range specified by a=
ddr
              and len.

(I assume the first sentence meant to say "specified by addr and len")

I agree with your interpretation, but there's no mention here that
MPOL_DEFAULT is treated differently and I don't see why it should be.


More broadly, I worry that it's too late to change this - existing
applications might fail if we change the implementation in the proposed
fashion.  So perhaps what we should do here is to change the manpage to
match reality?

Is the current behavior causing you any problems in a real-world use
case?
