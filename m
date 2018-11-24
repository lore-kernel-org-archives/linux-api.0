From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v3 3/4] libbpf: add bpf_prog_test_run_xattr
Date: Sat, 24 Nov 2018 14:20:13 -0800
Message-ID: <20181124222012.lcc6hn6vr6xbw7zr@ast-mbp.dhcp.thefacebook.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181122140910.1079-1-lmb@cloudflare.com>
 <20181122140910.1079-4-lmb@cloudflare.com>
 <b4308b6f-5a1d-f015-4e7f-abca1b3902be@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b4308b6f-5a1d-f015-4e7f-abca1b3902be@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>, ast@kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, ys114321@gmail.com
List-Id: linux-api@vger.kernel.org

On Fri, Nov 23, 2018 at 11:25:11PM +0100, Daniel Borkmann wrote:
> On 11/22/2018 03:09 PM, Lorenz Bauer wrote:
> > Add a new function, which encourages safe usage of the test interface.
> > bpf_prog_test_run continues to work as before, but should be considered
> > unsafe.
> > 
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> 
> Set looks good to me, thanks! Three small things below:
> 
> > ---
> >  tools/lib/bpf/bpf.c | 27 +++++++++++++++++++++++++++
> >  tools/lib/bpf/bpf.h | 13 +++++++++++++
> >  2 files changed, 40 insertions(+)
> > 
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 961e1b9fc592..f8518bef6886 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -424,6 +424,33 @@ int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
> >  	return ret;
> >  }
> >  
> > +int bpf_prog_test_run_xattr(const struct bpf_prog_test_run_attr *test_attr,
> > +			    __u32 *size_out, __u32 *retval, __u32 *duration)
> > +{
> > +	union bpf_attr attr;
> > +	int ret;
> > +
> > +	if (!test_attr->data_out && test_attr->size_out > 0)
> > +		return -EINVAL;
> > +
> > +	bzero(&attr, sizeof(attr));
> > +	attr.test.prog_fd = test_attr->prog_fd;
> > +	attr.test.data_in = ptr_to_u64(test_attr->data);
> > +	attr.test.data_out = ptr_to_u64(test_attr->data_out);
> > +	attr.test.data_size_in = test_attr->size;
> > +	attr.test.data_size_out = test_attr->size_out;
> > +	attr.test.repeat = test_attr->repeat;
> > +
> > +	ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
> > +	if (size_out)
> > +		*size_out = attr.test.data_size_out;
> > +	if (retval)
> > +		*retval = attr.test.retval;
> > +	if (duration)
> > +		*duration = attr.test.duration;
> > +	return ret;
> > +}
> > +
> >  int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id)
> >  {
> >  	union bpf_attr attr;
> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> > index 26a51538213c..570f19f77f42 100644
> > --- a/tools/lib/bpf/bpf.h
> > +++ b/tools/lib/bpf/bpf.h
> > @@ -110,6 +110,19 @@ LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
> >  LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
> >  LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
> >  				enum bpf_attach_type type);
> > +
> > +struct bpf_prog_test_run_attr {
> > +	int prog_fd;
> > +	int repeat;
> > +	const void *data;
> > +	__u32 size;
> > +	void *data_out; /* optional */
> > +	__u32 size_out;
> 
> Small nit: could we name these data_{in,out} and data_size_{in,out} as
> well, so it's analog to the ones from the bpf_attr?
> 
> > +};
> > +
> > +LIBBPF_API int bpf_prog_test_run_xattr(const struct bpf_prog_test_run_attr *test_attr,
> > +				       __u32 *size_out, __u32 *retval,
> > +				       __u32 *duration);

can we keep return values in struct bpf_prog_test_run_attr ?
I think the interface will be easier to use and faster. Less pointers
to pass around.

> >  LIBBPF_API int bpf_prog_test_run(int prog_fd, int repeat, void *data,
> >  				 __u32 size, void *data_out, __u32 *size_out,
> >  				 __u32 *retval, __u32 *duration);
> 
> Could we add a comment into the header here stating that we discourage
> bpf_prog_test_run()'s use?
> 
> It would probably also make sense since we go that route that we would
> convert the 10 bpf_prog_test_run() instances under test_progs.c at the
> same time so that people extending or looking at BPF kselftests don't
> copy discouraged bpf_prog_test_run() api as examples from this point
> onwards anymore.

I would keep bpf_prog_test_run() and test_progs.c as-is.
I think the prog_test_run in the current form is actually fine.
I don't find it 'unsafe'.
When it's called on a given bpf prog the user knows what prog
suppose to do. If prog is increasing the packet size the test writer
knows that and should size the output buffer accordingly.
Also there are plenty of tests where progs don't change the packet size
and any test with 'repeat > 1' should have the packet size
return to initial value. Like if the test is doing ipip encap
at the end of the run the bpf prog should remove that encap.
Otherwise 'repeat > 1' will produce wrong results.
