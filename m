From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 12:31:52 -0400
Message-ID: <20180326123152.67ce782f@gandalf.local.home>
References: <20180324023038.938665-1-ast@fb.com>
        <20180324023038.938665-7-ast@fb.com>
        <20180326115615.0ca53410@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326115615.0ca53410@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 11:56:15 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 23 Mar 2018 19:30:34 -0700
> Alexei Starovoitov <ast@fb.com> wrote:
> 
> > +static void *for_each_tracepoint_range(struct tracepoint * const *begin,
> > +				       struct tracepoint * const *end,
> > +				       void *(*fct)(struct tracepoint *tp, void *priv),
> > +				       void *priv)
> >  {
> >  	struct tracepoint * const *iter;
> > +	void *ret;
> >  
> >  	if (!begin)
> > -		return;
> > -	for (iter = begin; iter < end; iter++)
> > -		fct(*iter, priv);
> > +		return NULL;
> > +	for (iter = begin; iter < end; iter++) {
> > +		ret = fct(*iter, priv);
> > +		if (ret)
> > +			return ret;  
> 
> So you just stopped the loop here. You have an inconsistent state. What
> about the functions that were called before. How do you undo them? Or
> what about the rest that haven't been touched. This function gives no
> feedback to the caller.
> 

OK, I see my confusion with this patch. I much rather have a new
function, and this isn't about being nice to out of tree modules. We
can keep this function as is (to be nice), but my biggest squabble
about this patch is that the function name is inconsistent to what its
doing. When I have a function that says "for_each" I expect it to go
through each function and not exit out. This is because of what I said
above. When you have a "for_each" function that stops in the middle, you
have a state that you may need to deal with. How would another use of
that function clean up the mess if it expected to fail at some random
location.

I see in the next patch that you are using it simply to find a
tracepoint with the given name. I'd be much happier to add a new
function called:

   tracepoint_find_by_name(const char *name)

Because using a "for_each" to implement such a simple function seems
more of a hack.

-- Steve
