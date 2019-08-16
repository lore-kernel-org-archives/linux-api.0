From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Fri, 16 Aug 2019 12:52:35 -0700
Message-ID: <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
 <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
 <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch>
 <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de>
 <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch>
Sender: netdev-owner@vger.kernel.org
To: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 16, 2019 at 11:33:57AM +0000, Jordan Glover wrote:
> On Friday, August 16, 2019 9:59 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 16 Aug 2019, Jordan Glover wrote:
> >
> > > "systemd --user" service? Trying to do so will fail with:
> > > "Failed to apply ambient capabilities (before UID change): Operation not permitted"
> > > I think it's crucial to clear that point to avoid confusion in this discussion
> > > where people are talking about different things.
> > > On the other hand running "systemd --system" service with:
> > > User=nobody
> > > AmbientCapabilities=CAP_NET_ADMIN
> > > is perfectly legit and clears some security concerns as only privileged user
> > > can start such service.
> >
> > While we are at it, can we please stop looking at this from a systemd only
> > perspective. There is a world outside of systemd.
> >
> > Thanks,
> >
> > tglx
> 
> If you define:
> 
> "systemd --user" == unprivileged process started by unprivileged user
> "systemd --system" == process started by privileged user but run as another
> user which keeps some of parent user privileges and drops others
> 
> you can get rid of "systemd" from the equation.
> 
> "systemd --user" was the example provided by Alexei when asked about the usecase
> but his description didn't match what it does so it's not obvious what the real
> usecase is. I'm sure there can be many more examples and systemd isn't important
> here in particular beside to understand this specific example.

It's both of the above when 'systemd' is not taken literally.
To earlier Thomas's point: the use case is not only about systemd.
There are other containers management systems.
I've used 'systemd-like' terminology as an attempt to explain that such
daemons are trusted signed binaries that can be run as pid=1.
Sometimes it's the later:
"process started by privileged user but run as another user which keeps
some of parent user privileges and drops others".
Sometimes capability delegation to another container management daemon
is too cumbersome, so it's easier to use suid bit on that other daemon.
So it will become like the former:
"sort-of unprivileged process started by unprivileged user."
where daemon has suid and drops most of the capabilities as it starts.
Let's not focus on the model being good or bad security wise.
The point that those are the use cases that folks are thinking about.
That secondary daemon can be full root just fine.
All outer and inner daemons can be root.
These daemons need to drop privileges to make the system safer ==
less prone to corruption due to bugs in themselves. Not necessary security bugs.
