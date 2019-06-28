From: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 17/18] kernel/sysctl-test: Add null pointer test for
 sysctl.c:proc_dointvec()
Date: Fri, 28 Jun 2019 21:37:31 +0000
Message-ID: <20190628213731.GJ19023@42.do-not-panic.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-18-brendanhiggins@google.com>
 <20190626021744.GU19023@42.do-not-panic.com>
 <CAAXuY3p+kVhjQ4LYtzormqVcH2vKu1abc_K9Z0XY=JX=bp8NcQ@mail.gmail.com>
 <20190627061021.GE19023@42.do-not-panic.com>
 <CAFd5g45VJ9yfuESUc=E0ydJyN+mk1b1kyHSCYvO2x9KPC7+3GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFd5g45VJ9yfuESUc=E0ydJyN+mk1b1kyHSCYvO2x9KPC7+3GQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dominik Brodowski <linux-X3ehHDuj6sIIGcDfoQAp7OTW4wlIGRCZ@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Joel Stanley <joel>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 28, 2019 at 01:01:54AM -0700, Brendan Higgins wrote:
> On Wed, Jun 26, 2019 at 11:10 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Wed, Jun 26, 2019 at 09:07:43PM -0700, Iurii Zaikin wrote:
> > > On Tue, Jun 25, 2019 at 7:17 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > > > +static void sysctl_test_dointvec_table_maxlen_unset(struct kunit *test)
> > > > > +{
> > > > > +     struct ctl_table table = {
> > > > > +             .procname = "foo",
> > > > > +             .data           = &test_data.int_0001,
> > > > > +             .maxlen         = 0,
> > > > > +             .mode           = 0644,
> > > > > +             .proc_handler   = proc_dointvec,
> > > > > +             .extra1         = &i_zero,
> > > > > +             .extra2         = &i_one_hundred,
> > > > > +     };
> > > > > +     void  *buffer = kunit_kzalloc(test, sizeof(int), GFP_USER);
> > > > > +     size_t len;
> > > > > +     loff_t pos;
> > > > > +
> > > > > +     len = 1234;
> > > > > +     KUNIT_EXPECT_EQ(test, 0, proc_dointvec(&table, 0, buffer, &len, &pos));
> > > > > +     KUNIT_EXPECT_EQ(test, (size_t)0, len);
> > > > > +     len = 1234;
> > > > > +     KUNIT_EXPECT_EQ(test, 0, proc_dointvec(&table, 1, buffer, &len, &pos));
> > > > > +     KUNIT_EXPECT_EQ(test, (size_t)0, len);
> > > > > +}
> > > >
> > > > In a way this is also testing for general kernel API changes. This is and the
> > > > last one were good examples. So this is not just testing functionality
> > > > here. There is no wrong or write answer if 0 or -EINVAL was returned
> > > > other than the fact that we have been doing this for years.
> > > >
> > > > Its a perhaps small but important difference for some of these tests.  I
> > > > *do* think its worth clarifying through documentation which ones are
> > > > testing for API consistency Vs proper correctness.
> > >
> > > You make a good point that the test codifies the existing behavior of
> > > the function in lieu of formal documentation.  However, the test cases
> > > were derived from examining the source code of the function under test
> > > and attempting to cover all branches. The assertions were added only
> > > for the values that appeared to be set deliberately in the
> > > implementation. And it makes sense to me to test that the code does
> > > exactly what the implementation author intended.
> >
> > I'm not arguing against adding them. I'm suggesting that it is different
> > to test for API than for correctness of intended functionality, and
> > it would be wise to make it clear which test cases are for API and which
> > for correctness.
> 
> I see later on that some of the API stuff you are talking about is
> public APIs from the standpoint of user (outside of LInux) visible.

Right, UAPI.

> To
> be clear, is that what you mean by public APIs throughout, or would
> you distinguish between correctness tests, internal API tests, and
> external API tests?

I would definitely recommend distingishing between all of these.
Kernel API (or just call it API), UAPI, and correctness.

> > This will come up later for other kunit tests and it would be great
> > to set precendent so that other kunit tests can follow similar
> > practices to ensure its clear what is API realted Vs correctness of
> > intended functionality.
> >
> > In fact, I'm not yet sure if its possible to test public kernel API to
> > userspace with kunit, but if it is possible... well, that could make
> > linux-api folks happy as they could enable us to codify interpreation of
> > what is expected into kunit test cases, and we'd ensure that the
> > codified interpretation is not only documented in man pages but also
> > through formal kunit test cases.
> >
> > A regression in linux-api then could be formalized through a proper
> > kunit tests case. And if an API evolves, it would force developers to
> > update the respective kunit which codifies that contract.
> 
> Yep, I think that is long term hope. Some of the file system interface
> stuff that requires a filesystem to be mounted somewhere might get a
> little weird/difficult, but I suspect we should be able to do it
> eventually. I mean it's all just C code right? Should mostly boil down
> to someone figuring out how to do it the first time.

There used to be hacks in the kernel the call syscalls in a few places.
This was cleaned up and addressed via Dominik Brodowski's series last
year in March:

http://lkml.kernel.org/r/20180325162527.GA17492-SGhQLRGLuNwb6pqDj42GsMgv3T4z79SOrE5yTffgRl4@public.gmane.org

An example commit: d300b610812f3 ("kernel: use kernel_wait4() instead of
sys_wait4()").

So it would seem the work is done, and you'd just have to use the
respective exposed kernel_syscallname() calls, or add some if you
want to test a specific syscall in kernel space.

  Luis
