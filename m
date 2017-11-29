From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Wed, 29 Nov 2017 14:25:36 -0800
Message-ID: <CAGXu5jLa=b2HhjWXXTQunaZuz11qUhm5aNXHpS26jVqb=G-gfw@mail.gmail.com>
References: <20171129144219.22867-1-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171129144219.22867-1-mhocko@kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Linux API <linux-api@vger.kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 29, 2017 at 6:42 AM, Michal Hocko <mhocko@kernel.org> wrote:
> The first patch introduced MAP_FIXED_SAFE which enforces the given
> address but unlike MAP_FIXED it fails with ENOMEM if the given range
> conflicts with an existing one. The flag is introduced as a completely

I still think this name should be better. "SAFE" doesn't say what it's
safe from...

MAP_FIXED_UNIQUE
MAP_FIXED_ONCE
MAP_FIXED_FRESH

?

-Kees

-- 
Kees Cook
Pixel Security
