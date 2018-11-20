From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH 3/3] selftests: add a test for bpf_prog_test_run output size
Date: Tue, 20 Nov 2018 11:35:46 +0000
Message-ID: <CACAyw99F8L7BoB_TVAS6fvY9yb7cu9sCGXhjYPQ82sFZR=xKYQ@mail.gmail.com>
References: <20181116125329.3974-1-lmb@cloudflare.com> <20181116125329.3974-4-lmb@cloudflare.com>
 <CAH3MdRVd=ipYg+b9sGRR-FFUuOMjZ4OGZzkmJuFEShrYVXvwWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAH3MdRVd=ipYg+b9sGRR-FFUuOMjZ4OGZzkmJuFEShrYVXvwWA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Y Song <ys114321@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 18 Nov 2018 at 05:59, Y Song <ys114321@gmail.com> wrote:
>
> On Fri, Nov 16, 2018 at 12:55 PM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > Make sure that bpf_prog_test_run returns the correct length
> > in the size_out argument and that the kernel respects the
> > output size hint.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  tools/testing/selftests/bpf/test_progs.c | 34 ++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index 560d7527b86b..6ab98e10e86f 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -124,6 +124,39 @@ static void test_pkt_access(void)
> >         bpf_object__close(obj);
> >  }
> >
> > +static void test_output_size_hint(void)
> > +{
> > +       const char *file = "./test_pkt_access.o";
> > +       struct bpf_object *obj;
> > +       __u32 retval, size, duration;
> > +       int err, prog_fd;
> > +       char buf[10];
> > +
> > +       err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
> > +       if (err) {
> > +               error_cnt++;
> > +               return;
> > +       }
> CHECK can also be used here.
> if (CHECK(...)) {
>    goto done;
> }
> where label "done" is right before bpf_object__close.

I just copied this part from test_pkt_access, happy to change it though.
However, I think "goto done" would lead to freeing an unallocated
object in this case?

-- 
Lorenz Bauer  |  Systems Engineer
25 Lavington St., London SE1 0NZ

www.cloudflare.com
