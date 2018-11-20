From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 3/4] libbpf: require size hint in bpf_prog_test_run
Date: Tue, 20 Nov 2018 14:51:33 -0800
Message-ID: <20181120225131.ywfnf6r6a57dyhn2@ast-mbp.dhcp.thefacebook.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181120154306.16657-1-lmb@cloudflare.com>
 <20181120154306.16657-4-lmb@cloudflare.com>
 <20181120191808.gewk7ny5tshe56cm@ast-mbp.dhcp.thefacebook.com>
 <CACAyw993bwvo5obLgvWXbG_S6xRHXKZ9M1vX5=y1RB-R24LYdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACAyw993bwvo5obLgvWXbG_S6xRHXKZ9M1vX5=y1RB-R24LYdQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, linux-api@vger.kernel.org, Y Song <ys114321@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 20, 2018 at 07:43:57PM +0000, Lorenz Bauer wrote:
> On Tue, 20 Nov 2018 at 19:18, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Nov 20, 2018 at 03:43:05PM +0000, Lorenz Bauer wrote:
> > > Require size_out to be non-NULL if data_out is given. This prevents
> > > accidental overwriting of process memory after the output buffer.
> > >
> > > Adjust callers of bpf_prog_test_run to this behaviour.
> > >
> > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > ---
> > >  tools/lib/bpf/bpf.c                      |  7 ++++++-
> > >  tools/testing/selftests/bpf/test_progs.c | 10 ++++++++++
> > >  2 files changed, 16 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > > index 961e1b9fc592..1a835ff27486 100644
> > > --- a/tools/lib/bpf/bpf.c
> > > +++ b/tools/lib/bpf/bpf.c
> > > @@ -407,15 +407,20 @@ int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
> > >       union bpf_attr attr;
> > >       int ret;
> > >
> > > +     if (data_out && !size_out)
> > > +             return -EINVAL;
> > > +
> > >       bzero(&attr, sizeof(attr));
> > >       attr.test.prog_fd = prog_fd;
> > >       attr.test.data_in = ptr_to_u64(data);
> > >       attr.test.data_out = ptr_to_u64(data_out);
> > >       attr.test.data_size_in = size;
> > > +     if (data_out)
> > > +             attr.test.data_size_out = *size_out;
> > >       attr.test.repeat = repeat;
> > >
> > >       ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
> > > -     if (size_out)
> > > +     if (data_out)
> > >               *size_out = attr.test.data_size_out;
> > >       if (retval)
> > >               *retval = attr.test.retval;
> > > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > > index c1e688f61061..299938603cb6 100644
> > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > @@ -150,6 +150,7 @@ static void test_xdp(void)
> > >       bpf_map_update_elem(map_fd, &key4, &value4, 0);
> > >       bpf_map_update_elem(map_fd, &key6, &value6, 0);
> > >
> > > +     size = sizeof(buf);
> > >       err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
> > >                               buf, &size, &retval, &duration);
> > >
> > > @@ -158,6 +159,7 @@ static void test_xdp(void)
> > >             "err %d errno %d retval %d size %d\n",
> > >             err, errno, retval, size);
> > >
> > > +     size = sizeof(buf);
> > >       err = bpf_prog_test_run(prog_fd, 1, &pkt_v6, sizeof(pkt_v6),
> > >                               buf, &size, &retval, &duration);
> >
> > This will surely break existing bpf_prog_test_run users.
> > Like it will break our testing framework.
> > we can fix out stuff and libbpf is a user space library, but I don't
> > think that this is the case to invoke such pain.
> > libbpf's bpf_prog_test_run() should be a simple wrapper on top of syscall.
> > I don't think it should be making such restrictions on api.
> >
> > btw patch 1 looks good to me.
> >
> 
> What if I add bpf_prog_test_run_safe or similar, with the behaviour
> proposed in the patch?
> Makes sense that you don't want to break existing users of libbpf
> outside the kernel, OTOH
> user space really should specify the output buffer length (or be given
> the choice).

+     if (data_out && !size_out)
+             return -EINVAL;
+
+     if (data_out)
+             attr.test.data_size_out = *size_out;

this is actually worse than I thought, since it will cause sporadic
failures in the test frameworks that don't init size_out.
Like test_progs.c will be randomly passing/failing depending
on the state of uninit bytes in the stack.

Also consider that during bpf uconf folks have requested to extend
prog_test_run with __sk_buff in/out argument, so no only packet data,
but skb related fields can be tested as well.
I think that was a valid request and prog_test_run should be extended.
So soon such libbpf's bpf_prog_test_run_safe() will not be enough.
I think it's the best to use _xattr approach we did for map_create
and prog_load.
This new bpf_prog_test_run_xattr() will be able to do the check
you're proposing:
+     if (data_out && !size_out)
+             return -EINVAL;
+
+     if (data_out)
+             attr.test.data_size_out = *size_out;
it can also check that both size and size_out are sane
with similar check to kernel:
if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom);

and will be extendable in the near future with __sk_buff in/out.
