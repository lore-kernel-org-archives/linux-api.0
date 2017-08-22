From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] virt/lib avoids oops by adding parameter checking
Date: Tue, 22 Aug 2017 11:16:07 -0600
Message-ID: <20170822111607.0397a16d@w520.home>
References: <20170822010753.102857-1-nixiaoming@huawei.com>
        <e143dceb-55c7-2f9b-e034-740bffe6abd5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <e143dceb-55c7-2f9b-e034-740bffe6abd5@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: nixiaoming <nixiaoming@huawei.com>, kvm@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 22 Aug 2017 15:39:04 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 22/08/2017 03:07, nixiaoming wrote:
> > The error parameter passed through the external interface
> > causes the system oops. So it is necessary to increase the
> > parameter check for all EXPORT_SYMBOL_GPL
> > 
> > example:
> >  int irq_bypass_register_producer(struct irq_bypass_producer *producer)
> >  {
> >  	if (!producer->token) /* oops if producer == null */
> >  		return -einval;
> >  }
> >  EXPORT_SYMBOL_GPL(irq_bypass_register_producer);  
> 
> This is used like this:
> 
> drivers/vfio/pci/vfio_pci_intrs.c:		irq_bypass_unregister_producer(&vdev->ctx[vector].producer);
> drivers/vfio/pci/vfio_pci_intrs.c:	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
> virt/kvm/eventfd.c:	irq_bypass_unregister_consumer(&irqfd->consumer);
> virt/kvm/eventfd.c:		ret = irq_bypass_register_consumer(&irqfd->consumer);
> 
> So your check won't actually catch irqfd or vdev being NULL.

Additionally, I don't know of a reference to how extensively we should
harden these sorts of interfaces to misuse.  Just because a symbol is
exported doesn't necessarily mean that the function needs to be
hardened against misuse as we might for an interface exposed to a
user.  It's called by kernel mode code which can already do anything
it pleases to cause an oops.  If such hardening makes the calling
conventions or code flow easier, or results in a function that's easier
to use correctly or harder to misuse, then I think it's justified.  None
of that has been proven here and certainly doesn't seem to be the case
based on the current in-tree users.  Can the patch submitter justify
that this is "necessary" as claimed in the commit log?  Thanks,

Alex

> > Signed-off-by: nixiaoming <nixiaoming@huawei.com>
> > ---
> >  virt/lib/irqbypass.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> > index 6d2fcd6..2bb99e8 100644
> > --- a/virt/lib/irqbypass.c
> > +++ b/virt/lib/irqbypass.c
> > @@ -89,7 +89,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
> >  	struct irq_bypass_producer *tmp;
> >  	struct irq_bypass_consumer *consumer;
> >  
> > -	if (!producer->token)
> > +	if (!producer || !producer->token)
> >  		return -EINVAL;
> >  
> >  	might_sleep();
> > @@ -139,7 +139,7 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
> >  	struct irq_bypass_producer *tmp;
> >  	struct irq_bypass_consumer *consumer;
> >  
> > -	if (!producer->token)
> > +	if (!producer || !producer->token)
> >  		return;
> >  
> >  	might_sleep();
> > @@ -183,7 +183,7 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
> >  	struct irq_bypass_consumer *tmp;
> >  	struct irq_bypass_producer *producer;
> >  
> > -	if (!consumer->token ||
> > +	if (!consumer || !consumer->token ||
> >  	    !consumer->add_producer || !consumer->del_producer)
> >  		return -EINVAL;
> >  
> > @@ -234,7 +234,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
> >  	struct irq_bypass_consumer *tmp;
> >  	struct irq_bypass_producer *producer;
> >  
> > -	if (!consumer->token)
> > +	if (!consumer || !consumer->token)
> >  		return;
> >  
> >  	might_sleep();
> >   
> 
