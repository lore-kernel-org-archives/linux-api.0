From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/7] kernfs: Add API to generate relative kernfs path
Date: Tue, 8 Dec 2015 19:17:07 -0600
Message-ID: <20151209011707.GA18344@mail.hallyn.com>
References: <1449529582-4075-1-git-send-email-serge.hallyn@ubuntu.com>
	<1449529582-4075-2-git-send-email-serge.hallyn@ubuntu.com>
	<20151208115120.GB26797@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208115120.GB26797-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 08, 2015 at 06:51:20AM -0500, Greg KH wrote:
> On Mon, Dec 07, 2015 at 05:06:16PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> > From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > The new function kernfs_path_from_node() generates and returns kernfs
> > path of a given kernfs_node relative to a given parent kernfs_node.
> > 
> > Changelog 20151125:
> >   - Fully-wing multilinecomments
> >   - Rework kernfs_path_from_node_locked() logic
> >   - Replace BUG_ONs with returning NULL
> >   - Use a const char* for /.. and precalculate its size
> > Changelog 20151130:
> >   - Update kernfs_path_from_node_locked comment
> 
> changes should go below the --- line, not here in the body of the
> changelog that will show up in git :(

Right, thanks.  I've changed them all to add a --- before the changelog.
The format-patch ends up looking a bit weird with two --- lines, but
subsequent git am does the right thing, so hopefully this is the right
way.
