From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V33 29/30] tracefs: Restrict tracefs when the kernel is
 locked down
Date: Wed, 26 Jun 2019 12:39:31 -0700
Message-ID: <CACdnJuubBJxrybsV6+hyz9RyUR2AUyzy=4WJEeoYrNgbh_=FCQ@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-30-matthewgarrett@google.com> <20190626090748.23eba868@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190626090748.23eba868@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Morris <jmorris@namei.org>, linux-security@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 26, 2019 at 6:07 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 20 Jun 2019 18:19:40 -0700
> Matthew Garrett <matthewgarrett@google.com> wrote:
> > +static const struct file_operations tracefs_proxy_file_operations = {
> > +     .read =         default_read_file,
> > +     .write =        default_write_file,
> > +     .open =         default_open_file,
> > +     .llseek =       noop_llseek,
> > +};
>
> This appears to be unused.

Oops, yup - dropped.

> > +     dentry->d_fsdata = fops ? (void *)fops :
> > +             (void *)&tracefs_file_operations;
> > +     memcpy(proxy_fops, dentry->d_fsdata, sizeof(struct file_operations));
> > +     proxy_fops->open = default_open_file;
> >       inode->i_mode = mode;
> > -     inode->i_fop = fops ? fops : &tracefs_file_operations;
> > +     inode->i_fop = proxy_fops;
>
>
> I think the above would look cleaner as:
>
>
>         if (!fops)
>                 fops = &tracefs_file_operations;
>
>         dentry->d_fsdata = (void *)fops;
>         memcpy(proxy_fops, fops, sizeof(*proxy_fops);
>         proxy_fops->open = default_open_file;

ACK.
