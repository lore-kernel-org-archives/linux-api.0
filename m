From: Aaron Tomlin <atomlin@redhat.com>
Subject: Re: [PATCH RFC 4/5] mm/ksm, proc: introduce remote merge
Date: Thu, 16 May 2019 17:29:46 +0100
Message-ID: <20190516162946.zwzhxkft342b25pd@atomlin.usersys.com>
References: <20190516094234.9116-1-oleksandr@redhat.com>
 <20190516094234.9116-5-oleksandr@redhat.com>
 <CAG48ez2yXw_PJXO-mS=Qw5rkLpG6zDPd0saMhhGk09-du2bpaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez2yXw_PJXO-mS=Qw5rkLpG6zDPd0saMhhGk09-du2bpaA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Oleksandr Natalenko <oleksandr@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, Hugh Dickins <hughd@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Greg KH <greg@kroah.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>, Timofey Titovets <nefelim4ag@gmail.com>, Grzegorz Halat <ghalat@redhat.com>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu 2019-05-16 12:00 +0200, Jann Horn wrote:
> On Thu, May 16, 2019 at 11:43 AM Oleksandr Natalenko
> <oleksandr@redhat.com> wrote:
[ ... ]
> > +       }
> > +
> > +       down_write(&mm->mmap_sem);
> 
> Should a check for mmget_still_valid(mm) be inserted here? See commit
> 04f5866e41fb70690e28397487d8bd8eea7d712a.

Yes - I'd say this is required here.

Thanks,

-- 
Aaron Tomlin
