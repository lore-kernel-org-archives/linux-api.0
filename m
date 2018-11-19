From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] proc: allow killing processes via file descriptors (Larger pids)
Date: Mon, 19 Nov 2018 10:26:00 -0600
Message-ID: <875zwt2fvr.fsf_-_@xmission.com>
References: <20181118111751.6142-1-christian@brauner.io>
        <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
        <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
        <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
        <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
        <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org>
        <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
        <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
        <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
        <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
        <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com>
        <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
        <CAJwJo6aXQUtciO7kPSENoajV6JUqUGJxCh_0yPf5D8GfbLegzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJwJo6aXQUtciO7kPSENoajV6JUqUGJxCh_0yPf5D8GfbLegzA@mail.gmail.com>
        (Dmitry Safonov's message of "Mon, 19 Nov 2018 16:13:30 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, dancol@google.com, rdunlap@infradead.org, christian@brauner.io, open list <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, jannh@google.com, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, timmurray@google.com, Kees Cook <keescook@chromium.org>, jengelh@inai.de, Andrei Vagin <avagin@gmail.com>
List-Id: linux-api@vger.kernel.org

Dmitry Safonov <0x7f454c46@gmail.com> writes:
>
> So, I just wanted to gently remind about procfs with netlink socket[1].
> It seems to me that whenever you receive() pid information, you
> can request some uniq 64(?) bit number and kill the process using it.
> Whenever uniqueness of 64-bit number to handle pids will be a question
> the netlink message might be painlessly extended to 128 or whatever.

No.

I have seen this requested twice in this thread now, and despite
understanding where everyone is coming from I do not believe it will
be wise to implement larger pids.

The problem is that we then have to make these larger pids live in
the pid namespace, make struct pid larger to hold them and update
CRIU to save and restore them.

All for a very small handful of processes that use this extended API.

Eric
