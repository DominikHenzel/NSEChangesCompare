!#################################################################
!##############solving 3d navier stokes equation##################
!#################################################################
      
      program main
      implicit double precision(a-h,o-z)
      parameter(nx=100,ny=100,nz=100) ! Number of gridpoint
      parameter(dt=1.0D-003)    ! time step 
      parameter(Re=20.0D0)      ! Reynolds number
      parameter(Sc=1.0d0)   !Schmidt number
      parameter(xl=2.0d0)
      parameter(yl=2.0d0)
      parameter(zl=2.0d0)       !domain size
!     parameter(nnn=100000000) !number of iteration
      parameter(nnn=400)
      parameter(iflg=0)         !read field data? 1:yes 0:no
      parameter(int_rg=0)       !read 2D grid data? 1: yes 0:no
      parameter(int_rg3d=1)     !read 3D grid data? 1: yes 0:no
      parameter(eta=1000.0d0/dt) !for VPM term
      parameter(pi=3.14159265358979d0)
      parameter(thc_l=1.0d0)
      parameter(thc_s=1.0d0)
      parameter(rhoCp_l=1.0d0)
      parameter(rhoCp_s=1.0d0)

      integer nin1(0:nz+1)
      integer nin2(0:nz+1)
      integer nout1(0:nz+1)
      integer nout2(0:nz+1)

!#########################about velocity###########################
      
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision u_v(0:nx+1,0:ny+1,0:nz+1)
      double precision v_v(0:nx+1,0:ny+1,0:nz+1)
      double precision w_v(0:nx+1,0:ny+1,0:nz+1)
      double precision u_d(0:nx+1,0:ny+1,0:nz+1)
      double precision v_d(0:nx+1,0:ny+1,0:nz+1)
      double precision w_d(0:nx+1,0:ny+1,0:nz+1)
      double precision u_a(0:nx+1,0:ny+1,0:nz+1)
      double precision v_a(0:nx+1,0:ny+1,0:nz+1)
      double precision w_a(0:nx+1,0:ny+1,0:nz+1)
      double precision u_next(0:nx+1,0:ny+1,0:nz+1)
      double precision v_next(0:nx+1,0:ny+1,0:nz+1)
      double precision w_next(0:nx+1,0:ny+1,0:nz+1)
      double precision u_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision v_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision w_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision u_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision v_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision w_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision u_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision uuu(0:nx+1,0:ny+1,0:nz+1)
      double precision vvv(0:nx+1,0:ny+1,0:nz+1)
      double precision www(0:nx+1,0:ny+1,0:nz+1)
      double precision u_vpm(0:nx+1,0:ny+1,0:nz+1)
      double precision v_vpm(0:nx+1,0:ny+1,0:nz+1)
      double precision w_vpm(0:nx+1,0:ny+1,0:nz+1)            

!#######################about pressure##############################
      
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision divu(0:nx+1,0:ny+1,0:nz+1)
      
!#######################about grid##################################
      
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision x(0:nx+1),y(0:ny+1),z(0:nz+1)
      double precision x12(0:nx+1),y12(0:ny+1),z12(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)

!#######################about Level set#############################

      integer int_grid(1:nx,1:ny)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision phi(0:nx+1,0:ny+1,0:nz+1)
      double precision phi0(0:nx+1,0:ny+1,0:nz+1)
      double precision u_l(0:nx+1,0:ny+1,0:nz+1)
      double precision v_l(0:nx+1,0:ny+1,0:nz+1)
      double precision w_l(0:nx+1,0:ny+1,0:nz+1)
      double precision u_l_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision v_l_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision w_l_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision rad(0:nx+1,0:ny+1,0:nz+1)      

!#######################about Heat transfer#########################
      
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      double precision u_vT(0:nx+1,0:ny+1,0:nz+1)
      double precision u_dT(0:nx+1,0:ny+1,0:nz+1)
      double precision u_T(0:nx+1,0:ny+1,0:nz+1)
      double precision T_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision T_l(0:nx+1,0:ny+1,0:nz+1)
      double precision T_l_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision T_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision rhoCp(0:nx+1,0:ny+1,0:nz+1)
      double precision thc(0:nx+1,0:ny+1,0:nz+1)
      double precision T_before(0:nx+1,0:ny+1,0:nz+1)

!############################for check##############################      

      double precision u_ep1(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ep1(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ep1(0:nx+1,0:ny+1,0:nz+1)
      double precision u_ep2(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ep2(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ep2(0:nx+1,0:ny+1,0:nz+1)

!############################for adjoint#########################
      double precision u_final(0:nx+1,0:ny+1,0:nz+1)
      double precision v_final(0:nx+1,0:ny+1,0:nz+1)
      double precision w_final(0:nx+1,0:ny+1,0:nz+1)
      double precision p_final(0:nx+1,0:ny+1,0:nz+1)
      double precision T_final(0:nx+1,0:ny+1,0:nz+1)      

!#######################open mp parameters (KAMETANI)##############
      
      integer ompnproc,ompnthreads,ompmaxthreads
      integer omp_get_num_procs, omp_get_num_threads
      integer omp_get_thread_num, omp_get_max_threads
      double precision:: ten,tst
      ompnthreads=omp_get_max_threads()        
      
!#######################initialization##############################
!$omp parallel do schedule(STATIC) private(i,j,k)       
      do k=0,nz+1
         do j=0,ny+1
            do i=0,nx+1
               u(i,j,k)=0.0d0
               v(i,j,k)=0.0d0
               w(i,j,k)=0.0d0
               u_v(i,j,k)=0.0d0
               v_v(i,j,k)=0.0d0
               w_v(i,j,k)=0.0d0
               u_d(i,j,k)=0.0d0
               v_d(i,j,k)=0.0d0
               w_d(i,j,k)=0.0d0
               u_a(i,j,k)=0.0d0
               v_a(i,j,k)=0.0d0
               w_a(i,j,k)=0.0d0
               u_l(i,j,k)=0.0d0
               v_l(i,j,k)=0.0d0
               w_l(i,j,k)=0.0d0
               u_temp(i,j,k)=0.0d0
               v_temp(i,j,k)=0.0d0
               w_temp(i,j,k)=0.0d0
               u_pre(i,j,k)=0.0d0
               v_pre(i,j,k)=0.0d0
               w_pre(i,j,k)=0.0d0
               p(i,j,k)=0.0d0
               T(i,j,k)=0.0d0
               u_vT(i,j,k)=0.0d0
               u_dT(i,j,k)=0.0d0
               u_T(i,j,k)=0.0d0
               T_l(i,j,k)=0.0d0
               T_l_pre(i,j,k)=0.0d0
               T_pre(i,j,k)=0.0d0
               T_temp(i,j,k)=0.0d0
               rhoCp(i,j,k)=0.0d0
               thc(i,j,k)=0.0d0
               u_ta(i,j,k)=0.0d0
               v_ta(i,j,k)=0.0d0
               w_ta(i,j,k)=0.0d0
               uuu(i,j,k)=0.0d0
               vvv(i,j,k)=0.0d0
               www(i,j,k)=0.0d0
               phi0(i,j,k)=0.0d0
               phi(i,j,k)=0.0d0
               rad(i,j,k)=0.0d0

               u_ep1(i,j,k)=0.0d0
               v_ep1(i,j,k)=0.0d0
               w_ep1(i,j,k)=0.0d0
               u_ep2(i,j,k)=0.0d0
               v_ep2(i,j,k)=0.0d0
               w_ep2(i,j,k)=0.0d0
            enddo
         enddo
      enddo
!$omp end parallel do


      do i=0,nx+1
         x(i)=0.0d0
         x12(i)=0.0d0
         dx(i)=0.0d0
         dx12(i)=0.0d0
      enddo

      do j=0,ny+1
         y(j)=0.0d0
         y12(j)=0.0d0
         dy(j)=0.0d0
         dy12(j)=0.0d0
      enddo

      do k=0,nz+1
         z(k)=0.0d0
         z12(k)=0.0d0
         dz(k)=0.0d0
         dz12(k)=0.0d0
      enddo

      tid=0.0d0

      rhoCp=1.0d0
      thc=1.0d0
      write(6,*)"iflg=",iflg
!---------------------------set condition--------------------------
      call set_c(u,v,w,p,Re,nx,ny,nz,x,x12,y,y12,z,z12,dx,dx12,
     &     dy,dy12,dz,dz12,xl,yl,zl,T)      

!--------------------------reading part----------------------------


      if(int_rg3d.eq.1)then
         iflg3d=1
         write(6,*)"reading 3d grid file"
         call readgrid3d(nx,ny,nz,phi0)
         call set_levelset(nx,ny,nz,dx,dx12,dy,dy12,dz,dz12,
     &     phi0,phi,x,y,z,cellvalue)
      endif
!----------------------output-------------------
         open(1111,file="cellvalue.vtk")
         write(1111,"('# vtk DataFile Version 3.8.1')")
         write(1111,"('3D structure of vessel')")
         write(1111,"('ASCII ')")         
         write(1111,"('DATASET STRUCTURED_GRID')")
         write(1111,"('DIMENSIONS ',3(1x,i3))") nx, ny, nz         
         write(1111,"('POINTS ',i9,' float')") nx*ny*nz
         do k=1,nz
            do j=1,ny
               do i=1,nx
                  write(1111,"(3e15.7)") x(i), y(j), z(k)
               enddo
            enddo
         enddo
         
         write(1111,"('POINT_DATA ',i9)") nx*ny*nz
         
!     ! velocity vector (vector block)
         write(1111,"('SCALARS PHI float')")
         write(1111,"('LOOKUP_TABLE default')")
         do k=1,nz
            do j=1,ny
               do i=1,nx
                  write(1111,"(e15.7)") cellvalue(i,j,k,1)
               enddo
            enddo
         enddo
         close(1111)               
      
!------------------------------------------------------------------
      if(iflg.eq.1)then
         write(6,*) 'reading field file'
         call readfield(u,v,w,p,nx,ny,nz,tid,T,phi,
     &        u_ta,v_ta,w_ta)
         call set_bc(u,v,w,p,nx,ny,nz,T,
     &        x,y,z,dx,dy,dz,phi,at,nin1,nin2,nout1,nout2,
     &        area_in)
      else 
         write(6,*) 'Start from zero-initialized field'
      endif
!$omp parallel do schedule(STATIC) private(i,j,k) 
      do k=0,nz+1
         do j=0,ny+1
            do i=0,nx+1
               u_pre(i,j,k) = u(i,j,k)
               v_pre(i,j,k) = v(i,j,k)
               w_pre(i,j,k) = w(i,j,k)
               T_pre(i,j,k) = T(i,j,k)
            enddo
         enddo
      enddo
!$omp end parallel do

c     Main LOOP STARTS------------------------------------------------
      call system_clock(n_0)    !KAMETANI      
      do l = 1,nnn


         if(mod(l,300) .eq. 0)then
            int_report=1
            it50b=it50
            call system_clock(it50,it50r)
            write(6,*)'50 step time in sec :',(it50-it50b)/dble(it50r)
            call system_clock(itst)
         else
            int_report=0
         endif            
         tst = omp_get_wtime()  !KAMETANI
         if(int_report .eq. 1)then
            write(6,*)
            write(6,*) 'No. of iteration',l
            tid=tid+dt*100
            write(6,*) 'simulation time, t =',tid
         endif
         do k=0,nz+1
            do j=0,ny+1
               do i=0,nx+1
                  T_before(i,j,k)=T(i,j,k)
               enddo
            enddo
         enddo

         if(int_report .eq. 1)then         
            call system_clock(iti)
         endif

         call set_bc(u,v,w,p,nx,ny,nz,T,
     &        x,y,z,dx,dy,dz,phi,at,nin1,nin2,nout1,nout2,
     &        area_in)
                  
         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'set_bc:',(itf-iti)/dble(itr),'[s]'
            iti=itf
         endif

c     Calculating Forces
            call set_convect
     &     (u,u_v,v,v_v,w,w_v,Re,dt,nx,ny,nz,dx,dy,dz,
     &     dx12,dy12,dz12,cellvalue)

            

         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'set_convect:',(itf-iti)/dble(itr),'[s]'
            iti=itf
         endif

         call set_convection_for_scalar
     &        (u,v,w,Re,dt,nx,ny,nz,dx,dy,dz,
     &        dx12,dy12,dz12,T,u_vT,rhoCp)

         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'set_convection_for_scalar:',(itf-iti)/dble(itr),
     &           '[s]'
            iti=itf
         endif

         call set_conduction(u,u_d,v,v_d,w,w_d,Re,dt,nx,ny,nz,dx,dy,dz,
     &        dx12,dy12,dz12)

         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'set_conduction:',(itf-iti)/dble(itr),'[s]'
            iti=itf
         endif

         call set_diffusion_for_scalar
     &        (u,v,w,Re,dt,nx,ny,nz,dx,dy,dz,dx12,dy12,dz12,
     &        T,u_dT,Sc,thc,rhoCp)

         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'set_diffusion_for_scalar:',(itf-iti)/dble(itr),
     &           '[s]'
            iti=itf
         endif
!------------------------Immersed Boundary-----------------------------

         call set_Immersed_Boundary
     &        (u,u_pre,v,v_pre,w,w_pre,eta,x,y,z,nx,ny,nz,xl,yl,zl,dt,
     &        phi,u_l,v_l,w_l,dx,dy,dz,x12,y12,z12,pi,T,T_l,
     &        cellvalue,area_cell,u_ta,v_ta,w_ta,l,at,cons_cell,
     &        T_before)

         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'set_Immersed_Boundary:',(itf-iti)/dble(itr),
     &           '[s]'
            iti=itf
         endif
!--------------------------------------------------------------
          do k=0,nz+1
            do j=0,ny+1
               do i=0,nx+1
                  T_before(i,j,k)=T(i,j,k)
               enddo
            enddo
         enddo

c     Solve explicit parts 

         call set_explicit
     &        (u,u_v,u_pre,u_d,u_a,v,v_v,v_pre,v_d,v_a,
     &        w,w_v,w_pre,w_d,w_a,u_l,v_l,w_l,
     &        u_l_pre,v_l_pre,w_l_pre,nx,ny,nz,dt,l)

         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'set_explicit:',(itf-iti)/dble(itr),'[s]'
            iti=itf
         endif

         call set_explicit_for_tempreture
     &        (u_vT,u_dT,u_T,T_pre,T_l,T_l_pre,nx,ny,nz,dt,l)
         
         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'set_explicit_for_scalar:',(itf-iti)/dble(itr),
     &           '[s]'
            iti=itf
         endif

c     Solve implicit parts & calculate provisional velocity
!$omp parallel do schedule(STATIC) private(i,j,k)
         do k=1,nz
            do j=1,ny
               do i=1,nx
                  u_a(i,j,k)=(u(i,j,k)+u_a(i,j,k))
     &                 /(1.0d0+eta*cellvalue(i,j,k,2)*dt)
                  v_a(i,j,k)=(v(i,j,k)+v_a(i,j,k))
     &                 /(1.0d0+eta*cellvalue(i,j,k,3)*dt)                 
                  w_a(i,j,k)=(w(i,j,k)+w_a(i,j,k))
     &                 /(1.0d0+eta*cellvalue(i,j,k,4)*dt)
               enddo
            enddo
         enddo
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)
         do k=1,nz
            do j=1,ny
               do i=1,nx
                  u_T(i,j,k)=(T(i,j,k)+u_T(i,j,k))
     &                 /(1.0d0+eta*cellvalue(i,j,k,1)*dt)
               enddo
            enddo
         enddo
!$omp end parallel do
         call solve_u_temp
     &        (u_a,v_a,w_a,nx,ny,nz,dx,dy,dz,dx12,dy12,
     &        dz12,Re,dt,x,y,z,eta,cellvalue,phi,nin1,nin2,nout1,nout2,
     &        area_in,u_ta,v_ta,w_ta,u,v,w)

         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'solve_u_temp:',(itf-iti)/dble(itr),'[s]'
            iti=itf
         endif
         
!$omp parallel do schedule(STATIC) private(i,j,k)
         do k=0,nz+1
            do j=0,ny+1
               do i=0,nx+1
                  u_temp(i,j,k)=u_a(i,j,k)
                  v_temp(i,j,k)=v_a(i,j,k)
                  w_temp(i,j,k)=w_a(i,j,k)
               enddo
            enddo
         enddo
!$omp end parallel do

         call solve_t
     &        (u_T,nx,ny,nz,dx,dy,dz,dx12,dy12,dz12,Re,Sc,dt,
     &        rhoCp,thc,phi,cellvalue,eta)

         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'solve_t:',(itf-iti)/dble(itr),'[s]'
            iti=itf
         endif

!$omp parallel do schedule(STATIC) private(i,j,k)
         do k=1,nz
            do j=1,ny
               do i=1,nx
                  T(i,j,k)=u_T(i,j,k)
               enddo
            enddo
         enddo
!$omp end parallel do

c     Solving Poisson equation
         
c     call solve_p(p,u_temp,v_temp,w_temp,dt,dx,dy,dz,dx12,dy12,dz12,
c     &        Re,nx,ny,nz,res,res_max,res_int,res_var,ompnthreads)!KAMETANI
         call set_bc(u_temp,v_temp,w_temp,p,nx,ny,nz,T,
     &        x,y,z,dx,dy,dz,phi,at,nin1,nin2,nout1,nout2,
     &        area_in)


         CALL MKP(p,u_temp,v_temp,w_temp,dt,dx,dy,dz,dx12,dy12,dz12,
     &        Re,nx,ny,nz,res,res_max,res_int,res_var,ompnthreads,
     &        u_ta,v_ta,w_ta,u_ep2,v_ep2,w_ep2,divu,u,v,w,xl,zl) !KAMETANI

         call set_bc(u,v,w,p,nx,ny,nz,T,
     &        x,y,z,dx,dy,dz,phi,at,nin1,nin2,nout1,nout2,
     &        area_in)


         if(int_report .eq. 1)then
            call system_clock(itf,itr)
            write(6,*) 'MKP:',(itf-iti)/dble(itr),'[s]'
            iti=itf
         endif

c     Velocity 
c     call solve_u_next
c     &        (u,v,w,u_temp,v_temp,w_temp,p,dt,dx12,dy12,dz12,nx,ny,nz,
c     &        u_ta,v_ta,w_ta,u_ep2,v_ep2,w_ep2,divu,dx,dy,dz)


!--------------------------check Courant Number--------------------------


         
         if(int_report .eq. 1)then
            call check_courant(dt,dx,dy,dz,nx,ny,nz,u,v,w)
            call system_clock(itf,itr)
            write(6,*) 'check_courant:',(itf-iti)/dble(itr),'[s]'
            iti=itf
         endif
!----------------------------Data output---------------------------------
         if (l .eq. 0)then
            open(10,file='timely_convergence.dat',status='NEW')
            close(10)
         endif

!         if(mod(l,100) .eq. 0)then
         if(int_report .eq. 1)then
            write(*,*) 'call output'
            call output
     &           (u,v,w,p,x,y,z,x12,y12,z12,nx,ny,nz,T,cellvalue,
     &           u_ta,v_ta,w_ta,u_temp,v_temp,w_temp,eta,T_before,
     &           dx,dy,dz,dx12,dy12,dz12,phi,u_vpm,v_vpm,w_vpm,divu,
     &           rad)


            call check_convergence(y,yl,u,l,dt,Re,nx,ny,nz)         
         endif
         
         
         if(int_report .eq. 1)then
            write(*,*) 'call fielddata'
            call outfield(x,y,z,u,v,w,p,nx,ny,nz,tid,T,phi,
     &           u_ta,v_ta,w_ta)
         endif

         call monitor(nx,ny,nz,l,T,dx,dy,dz,dif,T_all,T_dif,T_before,
     &        u,v,w,vel_dif,u_dif,v_dif,w_dif,
     &        u_int_before,v_int_before,w_int_before,T_b,dt,int_report)

      if(int_report .eq. 1)then
         write(*,*)"Convergence of T_all =",dif
         write(*,*)"Convergence of T_dif =",T_dif
      endif

!     convergence condition

!     if(abs(dif).lt.1.0d-006)then
      if(int_report .eq. 1)then      
         write(*,*)"velocity difference is:",vel_dif
      endif
!########check wall clock time of one step (KAMETANI)#######
         
         ten = omp_get_wtime()
      if(int_report .eq. 1)then
         call system_clock(iten,itr)
         write(6,*) 'time for one step in sec',(iten-itst)/dble(itr)
      endif
      enddo

c     MAIN LOOP ENDS ----------------------------------------------------

c     Field data out put--- -------------------------
      
      write(6,*) 'End. Simulation time = ', dt*l
      write(6,*) 'Writing filed data'
      call outfield(x,y,z,u,v,w,p,nx,ny,nz,tid,T,phi,
     &     u_ta,v_ta,w_ta)
      write(*,*) 'call output'
      call system_clock(iti)
      call output
     &     (u,v,w,p,x,y,z,x12,y12,z12,nx,ny,nz,T,cellvalue,
     &     u_ta,v_ta,w_ta,u_temp,v_temp,w_temp,eta,T_before,
     &     dx,dy,dz,dx12,dy12,dz12,phi,u_vpm,v_vpm,w_vpm,divu,
     &     rad)      
         call system_clock(itf,itr)
         write(6,*) 'output:',(itf-iti)/dble(itr),'[s]'
         iti=itf
c     Check wall clock time to finish (KAMETANI)-------------------------
      
      call system_clock(n_1,n_rate)
      write(*,'("converging time = ",f8.3," sec.")')
     +     dble(n_1-n_0)/dble(n_rate)
      
c     ------------------------------------------------
      end

c     Main Program ends

c======================================================================

!######################################################################
!######################Subroutine Programs#############################
!######################################################################

!######################################################################
c     set condition
      
      subroutine set_c(u,v,w,p,Re,nx,ny,nz,x,x12,y,y12,z,z12,dx,dx12,
     &     dy,dy12,dz,dz12,xl,yl,zl,T)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision x(0:nx+1),y(0:ny+1),z(0:nz+1)
      double precision x12(0:nx+1),y12(0:ny+1),z12(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      
c     set grid
      
      do i = 0,nx+1
         x12(i)=xl*dble(i)/dble(nx)
         x  (i)=xl*(dble(i)-0.50d0)/dble(nx)
      enddo
      do j = 0,ny+1
         y12(j)=yl*dble(j)/dble(ny)
         y  (j)=yl*(dble(j)-0.50d0)/dble(ny)
      enddo
      do k = 0,nz+1
         z12(k)=zl*dble(k)/dble(nz)
         z  (k)=zl*(dble(k)-0.50d0)/dble(nz)
      enddo
c     dx,dy,dz
      do i=0,nx
         dx12(i)=x(i+1)-x(i)
      enddo
      dx12(nx+1)=2.0d0*(x12(nx+1)-x(nx+1))
      do i=1,nx+1
         dx(i)=x12(i)-x12(i-1)
      enddo
      dx(0)=dx(1)
      dx(nx+1)=dx(nx)

      do j=0,ny
         dy12(j)=y(j+1)-y(j)
      enddo
      dy12(ny+1)=2.0d0*(y12(ny+1)-y(ny+1))
      do j=1,ny+1
         dy(j)=y12(j)-y12(j-1)
      enddo
      dy(0)=dy(1)
      dy(ny+1)=dy(ny)

      do k=0,nz
         dz12(k)=z(k+1)-z(k)
      enddo
      dz12(nz+1)=2.0d0*(z12(nz+1)-z(nz+1))
      do k=1,nz+1
         dz(k)=z12(k)-z12(k-1)
      enddo
      dz(0)=dz(1)
      dz(nz+1)=dz(nz)

      return
      end

!#####################################################
c     set boundary condition
      subroutine set_bc(u,v,w,p,nx,ny,nz,T,
     &     x,y,z,dx,dy,dz,phi,at,nin1,nin2,nout1,nout2,
     &     area_in)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      double precision phi(0:nx+1,0:ny+1,0:nz+1)      
      double precision x(0:nx+1),y(0:ny+1),z(0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)

      integer nin1(0:nz+1)
      integer nin2(0:nz+1)
      integer nout1(0:nz+1)
      integer nout2(0:nz+1)      

c     about u
!$omp parallel do schedule(STATIC) private(i,j,k)
      do k = 0,nz+1
         do j = 0,ny+1
            u(0,j,k) = u(nx,j,k)
            u(nx+1,j,k) = u(1,j,k)
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k = 0,nz+1
         do i = 0,nx+1
            u(i,0,k) = -1.0d0*u(i,1,k)
            u(i,ny+1,k) = -1.0d0*u(i,ny,k)
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)        
      do j = 0,ny+1
         do i = 0,nx+1
            u(i,j,0) = u(i,j,nz)
            u(i,j,nz+1) = u(i,j,1)
         end do
      end do
!$omp end parallel do
      
c     about v
      
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k = 0,nz+1
         do j = 0,ny+1
            v(0,j,k) = v(nx,j,k)
            v(nx+1,j,k) = v(1,j,k)
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k=0,nz+1
         do i=0,nx+1
            v(i,0,k) = 0.0d0
            v(i,ny,k) = 0.0d0
         enddo
      enddo
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do j = 0,ny+1
         do i = 0,nx+1
            v(i,j,0) = v(i,j,nz)
            v(i,j,nz+1) = v(i,j,1)
         end do
      end do
!$omp end parallel do
      
c     about w
!$omp parallel do schedule(STATIC) private(i,j,k)        
      do k = 0,nz+1
         do j = 0,ny+1
            w(0,j,k) = w(nx,j,k)
            w(nx+1,j,k) = w(1,j,k)
         enddo
      enddo
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)        
      do k = 0,nz+1
         do i = 0,nx+1
            w(i,0,k) = -1.0d0*w(i,1,k)
            w(i,ny+1,k) = -1.0d0*w(i,ny,k)
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)        
      do j = 0,ny+1
         do i = 0,nx+1
            w(i,j,0)=w(i,j,nz)
            w(i,j,nz+1)=w(i,j,1)
!     w(i,j,0)=0.0d0
!     w(i,j,nz)=0.0d0
         end do
      end do
!$omp end parallel do
      
c     about p

!$omp parallel do schedule(STATIC) private(i,j,k)        
      do k = 0,nz+1
         do j = 0,ny+1
            p(0,j,k) = p(nx,j,k)
            p(nx+1,j,k) = p(1,j,k)
         enddo
      enddo
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k = 0,nz+1
         do i = 0,nx+1
            p(i,0,k) = p(i,1,k)
            p(i,ny+1,k) = p(i,ny,k)
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)        
      do j = 0,ny+1
         do i = 0,nx+1
            p(i,j,0) = p(i,j,nz)
            p(i,j,nz+1) = p(i,j,1)
         end do
      end do
!$omp end parallel do
!----------------------about T------------------------

!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k = 0,nz+1
         do j = 0,ny+1
            T(0,j,k) = T(nx,j,k)
            T(nx+1,j,k) = T(1,j,k)
         enddo
      enddo
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k=0,nz+1
         do i=0,nx+1
            T(i,0,k) = -1.0d0*T(i,1,k)
            T(i,ny+1,k) = -1.0*T(i,ny,k)
         enddo
      enddo
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do j=0,ny+1
         do i=0,nx+1
            T(i,j,0) = T(i,j,nz)
            T(i,j,nz+1) = T(i,j,1)
         enddo
      enddo
!     $omp end parallel do
      return
      end

!######################################################################
c     set convective term
      subroutine set_convect
     &     (u,u_v,v,v_v,w,w_v,Re,dt,nx,ny,nz,dx,dy,dz,
     &     dx12,dy12,dz12,cellvalue)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision u_v(0:nx+1,0:ny+1,0:nz+1)
      double precision v_v(0:nx+1,0:ny+1,0:nz+1)
      double precision w_v(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               u1=((u(i,j,k)+u(i+1,j,k))*(u(i,j,k)+u(i+1,j,k))
     &              -(u(i,j,k)+u(i-1,j,k))*(u(i,j,k)+u(i-1,j,k)))
     &              /dx12(i)
               u2=((v(i+1,j,k)*dx(i+1)+v(i,j,k)*dx(i))
     &              *(u(i,j+1,k)+u(i,j,k))
     &              -(v(i+1,j-1,k)*dx(i+1)+v(i,j-1,k)*dx(i))
     &              *(u(i,j,k)+u(i,j-1,k)))/dx12(i)/dy(j)
               u3=((w(i+1,j,k)*dx(i+1)+w(i,j,k)*dx(i))
     &              *(u(i,j,k+1)+u(i,j,k))
     &              -(w(i+1,j,k-1)*dx(i+1)+w(i,j,k-1)*dx(i))
     &              *(u(i,j,k)+u(i,j,k-1)))/dx12(i)/dz(k)
               u_v(i,j,k) = 0.25d0*(-u1-u2-u3)*dt+(1.0d0-cellvalue
     &(i,j,k,2))*dt
            enddo
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               v1=((u(i,j+1,k)*dy(j+1)+u(i,j,k)*dy(j))
     &              *(v(i+1,j,k)+v(i,j,k))
     &              -(u(i-1,j+1,k)*dy(j+1)+u(i-1,j,k)*dy(j))
     &              *(v(i,j,k)+v(i-1,j,k)))/dy12(j)/dx(i)
               v2=((v(i,j,k)+v(i,j+1,k))*(v(i,j,k)+v(i,j+1,k))
     &              -(v(i,j,k)+v(i,j-1,k))*(v(i,j,k)+v(i,j-1,k)))
     &              /dy12(j)
               v3=((w(i,j+1,k)*dy(j+1)+w(i,j,k)*dy(j))
     &              *(v(i,j,k+1)+v(i,j,k))
     &              -(w(i,j+1,k-1)*dy(j+1)+w(i,j,k-1)*dy(j))
     &              *(v(i,j,k)+v(i,j,k-1)))/dy12(j)/dz(k)
               v_v(i,j,k)= 0.25d0*(-v1-v2-v3)*dt
            end do
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               w1=((u(i,j,k+1)*dz(k+1)+u(i,j,k)*dz(k))
     &              *(w(i+1,j,k)+w(i,j,k))
     &              -(u(i-1,j,k+1)*dz(k+1)+u(i-1,j,k)*dz(k))
     &              *(w(i,j,k)+w(i-1,j,k)))/dz12(k)/dx(i)
               w2=((v(i,j,k+1)*dz(k+1)+v(i,j,k)*dz(k))
     &              *(w(i,j+1,k)+w(i,j,k))
     &              -(v(i,j-1,k+1)*dz(k+1)+v(i,j-1,k)*dz(k))
     &              *(w(i,j,k)+w(i,j-1,k)))/dz12(k)/dy(j)
               w3=((w(i,j,k)+w(i,j,k+1))*(w(i,j,k)+w(i,j,k+1))
     &              -(w(i,j,k)+w(i,j,k-1))*(w(i,j,k)+w(i,j,k-1)))
     &              /dz12(k)
               w_v(i,j,k) = 0.25d0*(-w1-w2-w3)*dt
            end do
         end do
      end do
!$omp end parallel do
      return
      end
!##########################################################################
!     set convection term for Scalar
      subroutine set_convection_for_scalar
     &     (u,v,w,Re,dt,nx,ny,nz,dx,dy,dz,
     &     dx12,dy12,dz12,T,u_vT,rhoCp)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      double precision u_vT(0:nx+1,0:ny+1,0:nz+1)
      double precision rhoCp(0:nx+1,0:ny+1,0:nz+1)
      

!$omp parallel do schedule(STATIC) private(i,j,k)        
      do k=1,nz
         do j=1,ny
            do i=1,nx
               uT=(
     &              -((rhoCp(i-1,j,k)*T(i-1,j,k)*dx(i)
     &              +rhoCp(i,j,k)*T(i,j,k)*dx(i-1))*u(i-1,j,k))
     &              /2.0d0/dx12(i-1)
     &              +((rhoCp(i,j,k)*T(i,j,k)*dx(i+1)
     &              +rhoCp(i+1,j,k)*T(i+1,j,k)*dx(i))*u(i,j,k))
     &              /2.0d0/dx12(i)
     &              )/dx(i)

               vT=(
     &              -((rhoCp(i,j-1,k)*T(i,j-1,k)*dy(j)
     &              +rhoCp(i,j,k)*T(i,j,k)*dy(j-1))*v(i,j-1,k))
     &              /2.0d0/dy12(j-1)         
     &              +((rhoCp(i,j,k)*T(i,j,k)*dy(j+1)
     &              +rhoCp(i,j+1,k)*T(i,j+1,k)*dy(j))*v(i,j,k))
     &              /2.0d0/dy12(j)
     &              )/dy(j)

               wT=(
     &              -((rhoCp(i,j,k-1)*T(i,j,k-1)*dz(k)
     &              +rhoCp(i,j,k)*T(i,j,k)*dz(k-1))*w(i,j,k-1))
     &              /2.0d0/dz12(k-1)         
     &              +((rhoCp(i,j,k)*T(i,j,k)*dz(k+1)
     &              +rhoCp(i,j,k+1)*T(i,j,k+1)*dz(k))*w(i,j,k))
     &              /2.0d0/dz12(k)
     &              )/dz(k)

               u_vT(i,j,k)=(-uT-vT-wT)*dt/rhoCp(i,j,k)+1.0d0*dt
            enddo
         enddo
      enddo
!$omp end parallel do
      end
      
!##########################################################################
c     set conduction term
      subroutine set_conduction
     &     (u,u_d,v,v_d,w,w_d,Re,dt,nx,ny,nz,dx,dy,dz,dx12,dy12,dz12)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision u_d(0:nx+1,0:ny+1,0:nz+1)
      double precision v_d(0:nx+1,0:ny+1,0:nz+1)
      double precision w_d(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
!$omp parallel do schedule(STATIC) private(i,j,k)        
      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               u1 = ((u(i+1,j,k)-u(i  ,j,k))/dx(i+1)
     +              -(u(i  ,j,k)-u(i-1,j,k))/dx(i))/dx12(i)
               u2 = ((u(i,j+1,k)-u(i,j  ,k))/dy12(j)
     +              -(u(i,j  ,k)-u(i,j-1,k))/dy12(j-1))/dy(j)
               u3 = ((u(i,j,k+1)-u(i,j,k  ))/dz12(k)
     +              -(u(i,j,k  )-u(i,j,k-1))/dz12(k-1))/dz(k)
               u_d(i,j,k) = dt/Re/2.0*(u1+u2+u3)
            end do
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               v1 = ((v(i+1,j,k)-v(i  ,j,k))/dx12(i)
     +              -(v(i  ,j,k)-v(i-1,j,k))/dx12(i-1))/dx(i)
               v2 = ((v(i,j+1,k)-v(i,j  ,k))/dy(j+1)
     +              -(v(i,j  ,k)-v(i,j-1,k))/dy(j))/dy12(j)
               v3 = ((v(i,j,k+1)-v(i,j,k  ))/dz12(k)
     +              -(v(i,j,k  )-v(i,j,k-1))/dz12(k-1))/dz(k)
               v_d(i,j,k) = dt/Re/2.0d0*(v1+v2+v3)
            end do
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               w1 = ((w(i+1,j,k)-w(i  ,j,k))/dx12(i)
     +              -(w(i  ,j,k)-w(i-1,j,k))/dx12(i-1))/dx(i)
               w2 = ((w(i,j+1,k)-w(i,j  ,k))/dy12(j)
     +              -(w(i,j  ,k)-w(i,j-1,k))/dy12(j-1))/dy(j)
               w3 = ((w(i,j,k+1)-w(i,j,k  ))/dz(k+1)
     +              -(w(i,j,k  )-w(i,j,k-1))/dz(k  ))/dz12(k)
               w_d(i,j,k) = dt/Re/2.0d0*(w1+w2+w3)

            end do
         end do
      end do
!$omp end parallel do
      return
      end

!####################################################################
!     set diffusion term for Scalar

      subroutine set_diffusion_for_scalar
     &     (u,v,w,Re,dt,nx,ny,nz,dx,dy,dz,dx12,dy12,dz12,
     &     T,u_dT,Sc,thc,rhoCp)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      double precision u_dT(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      double precision thc(0:nx+1,0:ny+1,0:nz+1)
      double precision rhoCp(0:nx+1,0:ny+1,0:nz+1)

      uT1=0.0d0
      uT2=0.0d0
      uT3=0.0d0
!$omp parallel do schedule(STATIC) private(i,j,k)  
      do k=1,nz
         do j=1,ny
            do i=1,nx
               
               uT1 = (
     &              ((dx(i+1)+dx(i))
     &              /(dx(i+1)/thc(i+1,j,k)+dx(i)/thc(i,j,k))
     &              *(T(i+1,j,k)-T(i,j,k))/dx12(i))
     &              -
     &              ((dx(i-1)+dx(i))
     &              /(dx(i-1)/thc(i-1,j,k)+dx(i)/thc(i,j,k))
     &              *(T(i,j,k)-T(i-1,j,k))/dx12(i-1))
     &              )/dx(i)
               
               uT2 = (
     &              ((dy(j+1)+dy(j))
     &              /(dy(j+1)/thc(i,j+1,k)+dy(j)/thc(i,j,k))
     &              *(T(i,j+1,k)-T(i,j,k))/dy12(j))
     &              -
     &              ((dy(j-1)+dy(j))
     &              /(dy(j-1)/thc(i,j-1,k)+dy(j)/thc(i,j,k))
     &              *(T(i,j,k)-T(i,j-1,k))/dy12(j-1))
     &              )/dy(j)

               uT3 = (
     &              (dz(k+1)+dz(k))
     &              /(dz(k+1)/thc(i,j,k+1)+dz(k)/thc(i,j,k))
     &              *(T(i,j,k+1)-T(i,j,k))/dz12(k)
     &              -
     &              (dz(k-1)+dz(k))
     &              /(dz(k-1)/thc(i,j,k-1)+dz(k)/thc(i,j,k))
     &              *(T(i,j,k)-T(i,j,k-1))/dz12(k-1)
     &              )/dz(k)
               
               u_dT(i,j,k)=(uT1+uT2+uT3)/2.0d0/Re/Sc/rhoCp(i,j,k)*dt
            enddo
         enddo
      enddo
!$omp end parallel do
      end subroutine


!--------------------------------------------------------------------
!-----------------------For Immersed Boundary------------------------
!--------------------------------------------------------------------

      subroutine set_Immersed_Boundary
     &     (u,u_pre,v,v_pre,w,w_pre,eta,x,y,z,nx,ny,nz,xl,yl,zl,dt,
     &     phi,u_l,v_l,w_l,dx,dy,dz,x12,y12,z12,pi,T,T_l,
     &     cellvalue,area_cell,u_ta,v_ta,w_ta,l,at,cons_cell,
     &     T_before)
      implicit double precision(a-h,o-z)
      integer int_grid(1:nx,1:ny)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision u_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision v_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision w_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision u_l(0:nx+1,0:ny+1,0:nz+1)
      double precision v_l(0:nx+1,0:ny+1,0:nz+1)
      double precision w_l(0:nx+1,0:ny+1,0:nz+1)
      double precision x(0:nx+1),y(0:ny+1),z(0:nz+1)
      double precision x12(0:nx+1),y12(0:ny+1),z12(0:nz+1)
      double precision phi(0:nx+1,0:ny+1,0:nz+1)
      double precision phi0(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      double precision T_l(0:nx+1,0:ny+1,0:nz+1)
      double precision u_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision T_before(0:nx+1,0:ny+1,0:nz+1)

      if(l.eq.1)then
         write(*,*)"set Immersed Boundary"
         phi_int=0.0d0
         do k=1,nz
            do j=1,ny
               do i=1,nx
                  phi_int=phi_int+cellvalue(i,j,k,1)*dx(i)*dy(j)*dz(k)
               enddo
            enddo
         enddo
         cons_cell=0.0d0         
         do k=1,nz
            do j=1,ny
               do i=1,nx-1
                  cellvalue(i,j,k,2)=
     &                 (cellvalue(i,j,k,1)+cellvalue(i+1,j,k,1))*0.50d0
               enddo
            enddo
         enddo

         do k=1,nz
            do j=1,ny
               cellvalue(nx,j,k,2)=cellvalue(nx,j,k,1)
            enddo
         enddo

         do k=1,nz
            do i=1,nx
               do j=1,ny-1
                  cellvalue(i,j,k,3)=
     &                 (cellvalue(i,j,k,1)+cellvalue(i,j+1,k,1))*0.50d0
               enddo
            enddo
         enddo

         do k=1,nz
            do i=1,nx
               cellvalue(i,ny,k,3)=cellvalue(i,ny,k,1)
            enddo
         enddo

         do j=1,ny
            do i=1,nx
               do k=1,nz-1
                  cellvalue(i,j,k,4)=
     &                 (cellvalue(i,j,k,1)+cellvalue(i,j,k+1,1))*0.50d0
               enddo
            enddo
         enddo

         do j=1,ny
            do i=1,nx
               cellvalue(i,j,nz,4)=cellvalue(i,j,nz,1)
            enddo
         enddo

      endif

!-----------------about u------------------

      do k=1,nz
         do j=1,ny
            do i=1,nx
               u_l(i,j,k)=
     &              eta*cellvalue(i,j,k,2)*u_ta(i,j,k)*dt
            enddo
         enddo
      enddo

!------------------about v-----------------      
      
      do k=1,nz
         do j=1,ny
            do i=1,nx
               v_l(i,j,k)=
     &              eta*cellvalue(i,j,k,3)*v_ta(i,j,k)*dt
            enddo
         enddo
      enddo

!--------------------about w------------------      

      do k=1,nz
         do j=1,ny
            do i=1,nx
               w_l(i,j,k)=
     &              eta*cellvalue(i,j,k,4)*w_ta(i,j,k)*dt
            enddo
         enddo
      enddo

!---------------------for tempreture-------------------------

      do k=1,nz
         do j=1,ny
            do i=1,nx     
c               T_l(i,j,k)=eta*cellvalue(i,j,k,1)*dt*T(i,j,k)
               T_l(i,j,k)=0.0d0
            enddo
         enddo
      enddo

!------------------------------------------------------------
      end subroutine
!####################################################################
c     set explicit term
      subroutine set_explicit
     &     (u,u_v,u_pre,u_d,u_a,v,v_v,v_pre,v_d,v_a,
     &     w,w_v,w_pre,w_d,w_a,u_l,v_l,w_l,
     &     u_l_pre,v_l_pre,w_l_pre,nx,ny,nz,dt,l)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision u_v(0:nx+1,0:ny+1,0:nz+1)
      double precision v_v(0:nx+1,0:ny+1,0:nz+1)
      double precision w_v(0:nx+1,0:ny+1,0:nz+1)
      double precision u_d(0:nx+1,0:ny+1,0:nz+1)
      double precision v_d(0:nx+1,0:ny+1,0:nz+1)
      double precision w_d(0:nx+1,0:ny+1,0:nz+1)
      double precision u_a(0:nx+1,0:ny+1,0:nz+1)
      double precision v_a(0:nx+1,0:ny+1,0:nz+1)
      double precision w_a(0:nx+1,0:ny+1,0:nz+1)
      double precision u_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision v_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision w_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision u_l(0:nx+1,0:ny+1,0:nz+1)
      double precision v_l(0:nx+1,0:ny+1,0:nz+1)
      double precision w_l(0:nx+1,0:ny+1,0:nz+1)
      double precision u_l_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision v_l_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision w_l_pre(0:nx+1,0:ny+1,0:nz+1)

      if(l.eq.1)then
         a1=1.0d0
         a2=0.0d0
         b1=1.0d0
      else
         a1=1.5d0
         a2=-0.5d0
         b1=1.0d0
      endif

      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               u_a(i,j,k) =(
     &              a1*u_v(i,j,k)+a2*u_pre(i,j,k)
     &              + b1*u_d(i,j,k)!+b1*u_l(i,j,k)
     &              )
            end do
         end do
      end do

!#########################periodic conditon######################
      
!     x direction
      do k=1,nz
         do j=1,ny
            u_a(0,j,k)=u_a(nx,j,k)
            u_a(nx+1,j,k)=u_a(1,j,k)
         enddo
      enddo

!     z direction
      do j=1,ny
         do i=1,nx
            u_a(i,j,0)=u_a(i,j,nz)
            u_a(i,j,nz+1)=u_a(i,j,1)
         enddo
      enddo

!###############################################################

      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               v_a(i,j,k) =(
     &              a1*v_v(i,j,k)+a2*v_pre(i,j,k)
     &              + b1*v_d(i,j,k)!+b1*v_l(i,j,k)
     &              )
            end do
         end do
      end do
!#########################periodic conditon######################
      
!     x direction
      do k=1,nz
         do j=1,ny
            v_a(0,j,k)=v_a(nx,j,k)
            v_a(nx+1,j,k)=v_a(1,j,k)
         enddo
      enddo

!     z direction
      do j=1,ny
         do i=1,nx
            v_a(i,j,0)=v_a(i,j,nz)
            v_a(i,j,nz+1)=v_a(i,j,1)
         enddo
      enddo

!###############################################################
      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               w_a(i,j,k) =(
     &              a1*w_v(i,j,k)+a2*w_pre(i,j,k)
     &              + b1*w_d(i,j,k)!+b1*w_l(i,j,k)
     &              )
            end do
         end do
      end do
!#########################periodic conditon######################
      
!     x direction
      do k=1,nz
         do j=1,ny
            w_a(0,j,k)=w_a(nx,j,k)
            w_a(nx+1,j,k)=w_a(1,j,k)
         enddo
      enddo

!     z direction
      do j=1,ny
         do i=1,nx
            w_a(i,j,0)=w_a(i,j,nz)
            w_a(i,j,nz+1)=w_a(i,j,1)
         enddo
      enddo

!###############################################################
      do k=1,nz
         do j=1,ny
            do i=1,nx
               u_pre(i,j,k)=u_v(i,j,k)
               v_pre(i,j,k)=v_v(i,j,k)
               w_pre(i,j,k)=w_v(i,j,k)
            enddo
         enddo
      enddo
      
      return
      end

!#################################################################
!     set explicit term for Scalar

      subroutine set_explicit_for_tempreture
     &     (u_vT,u_dT,u_T,T_pre,T_l,T_l_pre,nx,ny,nz,dt,l)
      implicit double precision(a-h,o-z)
      double precision u_vT(0:nx+1,0:ny+1,0:nz+1)
      double precision u_dT(0:nx+1,0:ny+1,0:nz+1)
      double precision u_T(0:nx+1,0:ny+1,0:nz+1)
      double precision T_pre(0:nx+1,0:ny+1,0:nz+1)
      double precision T_l(0:nx+1,0:ny+1,0:nz+1)
      double precision T_l_pre(0:nx+1,0:ny+1,0:nz+1)

      if(l.eq.1)then
         a1=1.0d0
         a2=0.0d0
         b1=1.0d0
      else
         a1=1.5d0
         a2=-0.5d0
         b1=1.0d0
      endif

      do k=1,nz
         do j=1,ny
            do i=1,nx
               u_T(i,j,k)=a1*u_vT(i,j,k)+a2*T_pre(i,j,k)
     &              +b1*u_dT(i,j,k)+b1*T_l(i,j,k)
            enddo
         enddo
      enddo
!#########################periodic_condition##############################
      do k=0,nz+1
         do j=0,ny+1
            u_T(0,j,k)=u_T(nx,j,k)
            u_T(nx+1,j,k)=u_T(1,j,k)
         enddo
      enddo
      do i=0,nx+1
         do j=0,ny+1
            u_T(i,j,0)=u_T(i,j,nz)
            u_T(i,j,nz+1)=u_T(i,j,0)
         enddo
      enddo
!#########################################################################

      do k=1,nz
         do j=1,ny
            do i=1,nx
               T_pre(i,j,k)=u_vT(i,j,k)
            enddo
         enddo
      enddo

      end subroutine

c     solve temporary u
      subroutine solve_u_temp
     &     (u_a,v_a,w_a,nx,ny,nz,dx,dy,dz,dx12,dy12,
     &     dz12,Re,dt,x,y,z,eta,cellvalue,phi,nin1,nin2,nout1,nout2,
     &     area_in,u_ta,v_ta,w_ta,u,v,w)      
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision u_a(0:nx+1,0:ny+1,0:nz+1)
      double precision v_a(0:nx+1,0:ny+1,0:nz+1)
      double precision w_a(0:nx+1,0:ny+1,0:nz+1)
      double precision u_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ta(0:nx+1,0:ny+1,0:nz+1)      
      double precision SUX(0:nx+1),SUY(0:ny+1),SUZ(0:nz+1)
      double precision SVX(0:nx+1),SVY(0:ny+1),SVZ(0:nz+1)
      double precision SWX(0:nx+1),SWY(0:ny+1),SWZ(0:nz+1)
      double precision CUX(1:nx),CUY(1:ny),CUZ(1:nz)
      double precision CVX(1:nx),CVY(1:ny),CVZ(1:nz)
      double precision CWX(1:nx),CWY(1:ny),CWZ(1:nz)
      double precision x(0:nx+1),y(0:ny+1),z(0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      double precision f(0:nx+1,0:ny+1,0:nz+1,1:3)
      double precision ft,fb
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision phi(0:nx+1,0:ny+1,0:nz+1)
      
      integer nin1(0:nz+1)
      integer nin2(0:nz+1)
      integer nout1(0:nz+1)
      integer nout2(0:nz+1)      

!---------------------------------------------------------------------
!     initialization

      do i=0,nx+1
         SUX(i)=0.0d0
         SVX(i)=0.0d0
         SWX(i)=0.0d0
      enddo

      do i=1,nx
         CUX(i)=0.0d0
         CVX(i)=0.0d0
         CWX(i)=0.0d0         
      enddo
      do j=0,ny+1
         SUY(j)=0.0d0
         SVY(j)=0.0d0
         SWY(j)=0.0d0
      enddo
      do j=1,ny
         CUY(j)=0.0d0
         CVY(j)=0.0d0
         CWY(j)=0.0d0         
      enddo
      do k=0,nz+1
         SUZ(k)=0.0d0
         SVZ(k)=0.0d0
         SWZ(k)=0.0d0         
      enddo
      do k=1,nz
         CUZ(k)=0.0d0
         CVZ(k)=0.0d0
         CWZ(k)=0.0d0         
      enddo

!-----------------------------------------------------------------------
!$omp parallel do schedule(static) private(i,k) 
      do i = 0,nx+1
         do k = 0,nz+1
            call parallel_uy(i,k,u_a,cellvalue,nx,ny,nz,dy,dy12,Re,
     &       dt,eta,2)
         end do      
      end do
!$omp end parallel do
!$omp parallel do schedule(static) private(i,j) 
      do i = 0,nx+1
         do j = 0,ny+1
            call parallel_z(i,j,u_a,cellvalue,nx,ny,nz,dz,dz12,Re,
     &           dt,eta,2)
         end do      
      end do
!$omp end parallel do
!$omp parallel do schedule(static) private(j,k)
      do j = 0,ny+1
         do k = 0,nz+1
            call parallel_x(j,k,u_a,cellvalue,nz,ny,nx,dx,dx12,Re,
     &           dt,eta,2)
         end do
      enddo
!$omp end parallel do
!$omp parallel do schedule(static) private(i,k)
      do i = 0,nx+1
         do k = 0,nz+1
            call parallel_vy(i,k,v_a,cellvalue,nx,ny,nz,dy,dy12,Re,
     &       dt,eta,3)
         end do      
      end do
!$omp end parallel do
!$omp parallel do schedule(static) private(i,j)
      do i = 0,nx+1
         do j = 0,ny+1
            call parallel_z(i,j,v_a,cellvalue,nx,ny,nz,dz,dz12,Re,
     &           dt,eta,3)
         end do
      end do
!$omp end parallel do
!$omp parallel do schedule(static) private(i,k)
      do j = 0,ny+1
         do k = 0,nz+1
            call parallel_x(j,k,v_a,cellvalue,nz,ny,nx,dx,dx12,Re,
     &           dt,eta,3)
         end do 
      end do
!$omp end parallel do
!$omp parallel do schedule(static) private(j,k)
      do i = 0,nx+1
         do k = 0,nz+1
!WE CHANGED THIS IN THE EVENING
           call parallel_uy(i,k,w_a,cellvalue,nx,ny,nz,dy,dy12,Re,
     &       dt,eta,4)
         end do      
      end do
!$omp end parallel do
!$omp parallel do schedule(static) private(j,k)
      do i = 0,nx+1
         do j = 0,ny+1
            call parallel_z(i,j,w_a,cellvalue,nx,ny,nz,dz,dz12,Re,
     &           dt,eta,4)
         end do      
      end do
!$omp end parallel do
!$omp parallel do schedule(static) private(j,k)
      do j = 0,ny+1
         do k = 0,nz+1
            call parallel_x(j,k,w_a,cellvalue,nz,ny,nx,dx,dx12,Re,
     &           dt,eta,4)
         end do 
      end do
!$omp end parallel do
      return
      end

!#############################################################
!     solve temporary T      
      subroutine solve_t
     &     (u_T,nx,ny,nz,dx,dy,dz,dx12,dy12,dz12,Re,Sc,dt,
     &     rhoCp,thc,phi,cellvalue,eta)      
      implicit double precision(a-h,o-z)
      double precision u_T(0:nx+1,0:ny+1,0:nz+1)
      double precision STX(0:nx+1),STY(0:ny+1),STZ(0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      double precision rhoCp(0:nx+1,0:ny+1,0:nz+1)
      double precision rrx(0:nx+1),rry(0:ny+1),rrz(0:nz+1)
      double precision thc(0:nx+1,0:ny+1,0:nz+1)
      double precision llx(0:nx+1),lly(0:ny+1),llz(0:nz+1)
      double precision f(0:nx+1,0:ny+1,0:nz+1)
      double precision ft,fb
      double precision phi(0:nx+1,0:ny+1,0:nz+1)
      double precision CUX(0:nx+1),CUY(0:ny+1),CUZ(0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)

      do k=0,nz+1
         do j=0,ny+1
            do i=0,nx+1
               f(i,j,k)=0.0d0
            enddo
         enddo
      enddo

      do k=0,nz+1
         do j=0,ny+1
            f(0,j,k)=2.0d0
         enddo
      enddo

!----------------------------------------------------------------
!$omp parallel do schedule(static) private(i,k) 
      do i=0,nx+1
         do k=0,nz+1
               call parallel_Ty(i,k,nx,ny,nz,rhoCp,thc,u_T,cellvalue,dy,
     &     dy12,Re,Sc,dt,eta)
         enddo
      enddo
!$omp end parallel do
!$omp parallel do schedule(static) private(i,k) 
      do j=0,ny+1
         do k=0,nz+1
            call parallel_Tx(k,j,nx,ny,nz,rhoCp,thc,u_T,cellvalue,dx,
     &     dx12,Re,Sc,dt,eta)
         enddo
      enddo
!$omp end parallel do
!$omp parallel do schedule(static) private(i,k) 
      do i=0,nx+1
         do j=0,ny+1
            call parallel_Tz(i,j,nx,ny,nz,rhoCp,thc,u_T,cellvalue,dz,
     &     dz12,Re,Sc,dt,eta)
         enddo
      enddo
!$omp end parallel do
      end subroutine

!##############################################################      
C     calculation with implicit method
      subroutine implicit_uy(SUY,ny,dy,dy12,Re,dt,ft,fb,eta,CUY)
      implicit double precision(a-h,o-z)
      double precision SUY(0:ny+1),a(0:ny+1,0:ny+1),u(0:ny+1)
      double precision dy(0:ny+1),dy12(0:ny+1)
      double precision CUY(1:ny)
      double precision alpha(1:ny)      

      beta = dt/Re/2.0d0
      
      do j=1,ny
         alpha(j) = dt*eta*CUY(j)+1.0d0
      enddo
      
C     about a
      do jj=0,ny+1
         do j=0,ny+1
            a(j,jj)=0.0d0
         enddo
      enddo
      do j = 1,ny
         a(j,j-1) = -beta/alpha(j)/dy12(j-1)/dy(j)
         a(j,j  ) = 1.0d0
     &        +beta/alpha(j)*(1.0d0/dy12(j)+1.0d0/dy12(j-1))/dy(j)
         a(j,j+1) = -beta/alpha(j)/dy12(j)/dy(j)
      end do

      a(0,0)=1.0d0
      a(0,1)=1.0d0
      a(ny+1,ny+1)=1.0d0
      a(ny+1,ny  )=1.0d0

!------------------------------------------------------------------------

      do j = 1,ny
         u(j) = SUY(j)
      end do
      
!-------------------------boundary condition----------------------------

      u(0)=ft
      u(ny+1)=fb

!-----------------------------------------------------------------------
      
C     from lower
      do j=ny+1,1,-1
         aa=a(j,j)
         a(j,j)=a(j,j)/aa       !equal 1.0d0
         a(j,j-1)=a(j,j-1)/aa
         bb=a(j-1,j)
         a(j-1,j)=a(j-1,j)-bb*a(j,j) !equal 0.0d0
         a(j-1,j-1)=a(j-1,j-1)-bb*a(j,j-1)

         u(j)=u(j)/aa
         u(j-1)=u(j-1)-bb*u(j)
      enddo
      
      do j=0,ny
         aa=a(j,j)
         a(j,j)=a(j,j)/aa       !equal 1.0d0
         bb=a(j+1,j)
         a(j+1,j)=a(j+1,j)-bb*a(j,j) !equal 0.0d0
         
         u(j)=u(j)/aa
         u(j+1)=u(j+1)-bb*u(j)
      enddo
      
      do j = 0,ny+1
         SUY(j) = u(j)
      end do

      return
      end


      
!#######################################################################

      subroutine implicit_vy(SVY,ny,dy,dy12,Re,dt,ft,fb,eta,CVY)
      implicit double precision(a-h,o-z)
      double precision SVY(0:ny+1),a(0:ny,0:ny),u(0:ny)
      double precision dy(0:ny+1),dy12(0:ny+1)
      double precision CVY(1:ny)
      double precision alpha(1:ny)            

      beta = dt/Re/2.0d0
      
      do j=1,ny-1
         alpha(j) = dt*eta*CVY(j)+1.0d0
      enddo      

      do jj=0,ny
         do j=0,ny
            a(j,jj)=0.0d0
         enddo
      enddo

      a(0,0)=1.0d0
      a(ny,ny)=1.0d0

      do j = 1,ny-1
         a(j,j-1) = -beta/alpha(j)/dy(j)/dy12(j)
         a(j,j  ) = 1.0d0
     &        +beta/alpha(j)*(1.0d0/dy(j+1)+1.0d0/dy(j))/dy12(j)
         a(j,j+1) = -beta/alpha(j)/dy(j+1)/dy12(j)
      end do

      do j = 1,ny-1
         u(j) = SVY(j)
      end do

      u(0)=ft !OKAY
      u(ny)=fb

C     from lower
      
      do j=ny,1,-1
         aa=a(j,j)
         a(j,j)=a(j,j)/aa       !equal 1.0d0
         a(j,j-1)=a(j,j-1)/aa
         bb=a(j-1,j)
         a(j-1,j)=a(j-1,j)-bb*a(j,j) !equal 0.0d0
         a(j-1,j-1)=a(j-1,j-1)-bb*a(j,j-1)

         u(j)=u(j)/aa
         u(j-1)=u(j-1)-bb*u(j)
      enddo
      
      do j=0,ny-1
         aa=a(j,j)
         a(j,j)=a(j,j)/aa       !equal 1.0d0
         bb=a(j+1,j)
         a(j+1,j)=a(j+1,j)-bb*a(j,j) !equal 0.0d0
         
         u(j)=u(j)/aa
         u(j+1)=u(j+1)-bb*u(j)
      enddo
      
      do j = 0,ny
         SVY(j) = u(j)
      end do
      
      return
      end


!#########################################################################
      subroutine implicit_wy(SWY,ny,dy,dy12,Re,dt,ft,fb,eta,CWY)
      implicit double precision(a-h,o-z)
      double precision SWY(0:ny+1),a(0:ny+1,0:ny+1),u(0:ny+1)
      double precision dy(0:ny+1),dy12(0:ny+1)
      double precision CWY(1:ny)
      double precision alpha(1:ny)
      
      beta = dt/Re/2.0d0
      
      do j=1,ny
         alpha(j) = dt*eta*CWY(j)+1.0d0
      enddo            
      
      do jj=0,ny+1
         do j=0,ny+1
            a(j,jj)=0.0d0
         enddo
      enddo
      
      do j = 1,ny
         a(j,j-1) = -beta/alpha(j)/dy12(j-1)/dy(j)
         a(j,j  ) = 1.0d0
     &        +beta/alpha(j)*(1.0d0/dy12(j)+1.0d0/dy12(j-1))/dy(j)
         a(j,j+1) = -beta/alpha(j)/dy12(j)/dy(j)
      end do
      
      a(0,0)=1.0d0
      a(0,1)=1.0d0
      a(ny+1,ny  )=1.0d0
      a(ny+1,ny+1)=1.0d0

      do j = 1,ny
         u(j) = SWY(j)
      end do
      
!-------------------------boundary condition----------------------------
      
      u(0)=ft
      u(ny+1)=fb

!-----------------------------------------------------------------------
      
C     from lower
      do j=ny+1,1,-1
         aa=a(j,j)
         a(j,j)=a(j,j)/aa       !equal 1.0d0
         a(j,j-1)=a(j,j-1)/aa
         bb=a(j-1,j)
         a(j-1,j)=a(j-1,j)-bb*a(j,j) !equal 0.0d0
         a(j-1,j-1)=a(j-1,j-1)-bb*a(j,j-1)

         u(j)=u(j)/aa
         u(j-1)=u(j-1)-bb*u(j)
      enddo
      
      do j=0,ny
         aa=a(j,j)
         a(j,j)=a(j,j)/aa       !equal 1.0d0
         bb=a(j+1,j)
         a(j+1,j)=a(j+1,j)-bb*a(j,j) !equal 0.0d0
         
         u(j)=u(j)/aa
         u(j+1)=u(j+1)-bb*u(j)
      enddo
      
      do j = 0,ny+1
         SWY(j) = u(j)
      enddo
      
      return
      end
!---------------------implicit Scalar----------------------

      subroutine implicit_Tx
     &     (STX,nx,dx,dx12,Re,Sc,dt,llx,rrx,ft,fb,
     &     eta,CUX)
      implicit double precision(a-h,o-z)
      double precision STX(0:nx+1),a(0:nx+1,0:nx+1),T(0:nx+1)
      double precision dx(0:nx+1),dx12(0:nx+1)
      double precision rrx(0:nx+1)
      double precision llx(0:nx+1)
      double precision aa(0:nx+1),bb(0:nx+1),cc(0:nx+1)
      double precision alpha(1:nx)
      double precision CUX(0:nx+1)
      beta = dt/Re/Sc/2.0d0
      do i=1,nx
         alpha(i)=dt*eta*CUX(i)+1.0d0
      enddo
      
      
      do i=1,nx
         T(i) = STX(i)
      enddo

!---------------------boundary condition------------------------------

      T(0)=ft
      T(nx+1)=fb

!---------------------------------------------------------------------
      do i=1,nx
         aa(i) = -beta/alpha(i)*(
     &        (dx(i)+dx(i-1))
     &        /(dx(i)/llx(i)+dx(i-1)/llx(i-1)))/dx12(i-1)/dx(i)
     &        /rrx(i)
         
         bb(i) = 1.0d0+beta/alpha(i)*(
     &        ((dx(i+1)+dx(i))
     &        /(dx(i+1)/llx(i+1)+dx(i)/llx(i))/dx12(i)/dx(i))
     &        +
     &        ((dx(i)+dx(i-1))
     &        /(dx(i)/llx(i)+dx(i-1)/llx(i-1))/dx12(i-1)/dx(i))
     &        )/rrx(i)
         
         cc(i) = -beta/alpha(i)*(
     &        (dx(i+1)+dx(i))
     &        /(dx(i+1)/llx(i+1)+dx(i)/llx(i)))/dx12(i)/dx(i)
     &        /rrx(i)
      enddo
      aa(0)=0.0d0
      bb(0)=0.0d0
      cc(0)=1.0d0
      topright=-1.0d0
      bottomleft=-1.0d0
      aa(nx+1)=1.0d0
      bb(nx+1)=0.0d0
      cc(nx+1)=0.0d0
      call cyclic(aa,bb,cc,bottomleft,topright,T,STX,nx)

      end subroutine

!##############################################################
      subroutine implicit_Ty
     &     (STY,ny,dy,dy12,Re,Sc,dt,lly,rry,ft,fb,CUY,eta)
      implicit double precision(a-h,o-z)
      double precision STY(0:ny+1),a(0:ny+1,0:ny+1),T(0:ny+1)
      double precision dy(0:ny+1),dy12(0:ny+1)
      double precision rry(0:ny+1)
      double precision lly(0:ny+1)
      double precision CUY(0:ny+1)
      double precision alpha(1:ny)

      beta = dt/Re/Sc/2.0d0
      
      do j=1,ny
         alpha(j)=dt*eta*CUY(j)+1.0d0
      enddo

      do i=0,ny+1
         do j=0,ny+1
            a(i,j)=0.0d0
         enddo
      enddo
      
      a(0,0)=1.0d0
      a(0,1)=1.0d0
      a(ny+1,ny+1)=1.0d0
      a(ny+1,ny)=1.0d0         

      do i=1,ny
         a(i,i-1) = -beta/alpha(i)*(
     &        (dy(i)+dy(i-1))
     &        /(dy(i)/lly(i)+dy(i-1)/lly(i-1)))/dy12(i-1)/dy(i)
     &        /rry(i)
         
         a(i,i) = 1.0d0+beta/alpha(i)*(
     &        ((dy(i+1)+dy(i))
     &        /(dy(i+1)/lly(i+1)+dy(i)/lly(i))/dy12(i)/dy(i))
     &        +
     &        ((dy(i)+dy(i-1))
     &        /(dy(i)/lly(i)+dy(i-1)/lly(i-1))/dy12(i-1)/dy(i))
     &        )/rry(i)
         
         a(i,i+1) = -beta/alpha(i)*(
     &        (dy(i+1)+dy(i))
     &        /(dy(i+1)/lly(i+1)+dy(i)/lly(i)))/dy12(i)/dy(i)
     &        /rry(i)
      enddo



      do i=1,ny
         T(i) = STY(i)
      enddo
      
!----------------------boundary condition-------------------------

      T(0)=ft
      T(ny+1)=fb
      
!------------------------------------------------------------------
      
      do i=ny+1,1,-1
         aa=a(i,i)
         a(i,i)=a(i,i)/aa       !equal 1.0d0
         a(i,i-1)=a(i,i-1)/aa
         bb=a(i-1,i)
         a(i-1,i)=a(i-1,i)-bb*a(i,i) !equal 0.0d0
         a(i-1,i-1)=a(i-1,i-1)-bb*a(i,i-1)

         T(i)=T(i)/aa
         T(i-1)=T(i-1)-bb*T(i)
      enddo
      
      do i=0,ny
         aa=a(i,i)
         a(i,i)=a(i,i)/aa       !equal 1.0d0
         bb=a(i+1,i)
         a(i+1,i)=a(i+1,i)-bb*a(i,i) !equal 0.0d0
         
         T(i)=T(i)/aa
         T(i+1)=T(i+1)-bb*T(i)
      enddo
      
      do i = 1,ny
         STY(i) = T(i)
      end do

      end subroutine

!#################################################################
      subroutine implicit_Tz
     &     (S,nx,ny,nz,dz,dz12,Re,Sc,dt,rhoCp,thc,llz,rrz,ft,fb)
      implicit double precision(a-h,o-z)
      double precision S(0:nz+1),a(0:nz+1,0:nz+1),T(0:nz+1)
      double precision dz(0:nz+1),dz12(0:nz+1)
      double precision rhoCp(0:nx+1,0:ny+1,0:nz+1)
      double precision rrz(0:nz+1)
      double precision thc(0:nx+1,0:ny+1,0:nz+1)
      double precision llz(0:nz+1)

      beta = dt/Re/Sc/2.0d0

      do i=0,nz+1
         do j=0,nz+1
            a(i,j)=0.0d0
         enddo
      enddo

      a(0,0)=1.0d0
      a(0,1)=-1.0d0
      a(nz+1,nz)=-1.0d0
      a(nz+1,nz+1)=1.0d0

      do i=1,nz
         a(i,i-1) = -beta*(
     &        (dz(i)+dz(i-1))
     &        /(dz(i)/llz(i)+dz(i-1)/llz(i-1)))/dz12(i-1)/dz(i)
     &        /rrz(i)
         
         a(i,i)   = 1.0d0+beta*(
     &        ((dz(i+1)+dz(i))
     &        /(dz(i+1)/llz(i+1)+dz(i)/llz(i))/dz12(i)/dz(i))
     &        +
     &        ((dz(i)+dz(i-1))
     &        /(dz(i)/llz(i)+dz(i-1)/llz(i-1))/dz12(i-1)/dz(i))
     &        )/rrz(i)
         
         a(i,i+1) = -beta*(
     &        (dz(i+1)+dz(i))
     &        /(dz(i+1)/llz(i+1)+dz(i)/llz(i)))/dz12(i)/dz(i)
     &        /rrz(i)
      enddo

      do i=1,nz
         T(i) = S(i)
      enddo

!-----------------------boundary condition-------------------------

      T(0)=ft
      T(nz+1)=fb

!------------------------------------------------------------------
      
      do i=nz+1,1,-1
         aa=a(i,i)
         a(i,i)=a(i,i)/aa       !equal 1.0d0
         a(i,i-1)=a(i,i-1)/aa
         bb=a(i-1,i)
         a(i-1,i)=a(i-1,i)-bb*a(i,i) !equal 0.0d0
         a(i-1,i-1)=a(i-1,i-1)-bb*a(i,i-1)

         T(i)=T(i)/aa
         T(i-1)=T(i-1)-bb*T(i)
      enddo
      
      do i=0,nz
         aa=a(i,i)
         a(i,i)=a(i,i)/aa       !equal 1.0d0
         bb=a(i+1,i)
         a(i+1,i)=a(i+1,i)-bb*a(i,i) !equal 0.0d0
         
         T(i)=T(i)/aa
         T(i+1)=T(i+1)-bb*T(i)
      enddo
      
      do i = 1,nz
         S(i) = T(i)
      end do

      end subroutine
      
!#####################################################################
c     solve p
      subroutine solve_p(p,u_temp,v_temp,w_temp,dt,dx,dy,dz,dx12,dy12
     &     ,dz12,Re,nx,ny,nz,res,res_max,res_int,res_var,ompnthreads)
      implicit double precision(a-h,o-z)
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision u_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision v_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision w_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision p_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision p_prev(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      integer ompnthreads

      nnn=100000
      do lll=1,nnn

!     call explicit(p,u_temp,v_temp,w_temp,dx,dy,dz,
!     &        dx12,dy12,dz12,nx,ny,nz,dt,ompnthreads)

         call linebyline
     &        (nx,ny,nz,u_temp,v_temp,w_temp,dx,dy,dz,dx12,dy12,dz12,
     &        dt,p)         

         res=0.0d0
         res_max=0.0d0
         res_int=0.0d0
         res_var=0.0d0
         
         do k=1,nz
            do j=1,ny
               do i=1,nx
                  
                  div=(u_temp(i,j,k)-u_temp(i-1,j,k))/dx(i)
     &                 +(v_temp(i,j,k)-v_temp(i,j-1,k))/dy(j)
     &                 +(w_temp(i,j,k)-w_temp(i,j,k-1))/dz(k)
                  
                  pphi = (((p(i+1,j,k)-p(i,j,k))/dx12(i)
     &                 -(p(i,j,k)-p(i-1,j,k))/dx12(i-1))/dx(i)
     &                 +((p(i,j+1,k)-p(i,j,k))/dy12(j)
     &                 -(p(i,j,k)-p(i,j-1,k))/dy12(j-1))/dy(j)
     &                 +((p(i,j,k+1)-p(i,j,k))/dz12(k)
     &                 -(p(i,j,k)-p(i,j,k-1))/dz12(k-1))/dz(k))
                  
                  res = dabs(pphi*dt-div)
                  if(res .ge. res_max)then
                     res_max=res
                  endif
                  
                  res_int = res_int + (pphi*dt-div)*dx(i)*dy(j)*dz(k) 
                  res_var = res_var + (res*res)*dx(i)*dy(j)*dz(k)
               enddo
            enddo
         enddo

         if(res_max.lt.1.0d-005)then
            write(*,*)"convergence of poisson =",res_max
            exit
         endif
         if(lll.eq.nnn)then
            write(*,*)"convergence of poisson =",res_max
         endif
         
      enddo
      
      write(*,*)"res = ",res
      write(*,*)"res_maximum = ",res_max
      write(*,*)"res_integral = ",res_int
      write(*,*)"res_var = ",res_var
      
      end
      
!###########################################################
C     calculation with implicit method
      subroutine explicit(p,u_temp,v_temp,w_temp,dx,dy,dz,
     &     dx12,dy12,dz12,nx,ny,nz,dt,ompnthreads)
      implicit double precision(a-h,o-z)
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision p_next(0:nx+1,0:ny+1,0:nz+1)
      double precision u_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision v_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision w_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision q(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      integer ompnthreads
!     $    include 'omp_lib.h' !(KAMETANI)      

!$omp parallel
!$omp do schedule(STATIC) collapse(2)      
      do k=1,nz
         do j=1,ny
            do i=1,nx
               q(i,j,k)=0.0d0
            enddo
         enddo
      enddo
!$omp end do
!$omp end parallel      

!-----------------------------------------------------------------

!$omp parallel private(b0)
!$omp do schedule(STATIC) collapse(2)      
      do k=1,nz
         do j=1,ny
            do i=1,nx
               
               b0=(1.0d0/dx(i)/dx12(i)+1.0d0/dx(i)/dx12(i-1)
     &              +1.0d0/dy(j)/dy12(j)+1.0d0/dy(j)/dy12(j-1)
     &              +1.0d0/dz(k)/dz12(k)+1.0d0/dz(k)/dz12(k-1)
     &              )

               q(i,j,k)=(
     &              (u_temp(i,j,k)-u_temp(i-1,j,k))/dx(i)
     &              +(v_temp(i,j,k)-v_temp(i,j-1,k))/dy(j)
     &              +(w_temp(i,j,k)-w_temp(i,j,k-1))/dz(k)
     &              )/dt

               p(i,j,k)=p(i,j,k)+(
     &              ((p(i+1,j,k)-p(i,j,k))/dx12(i)
     &              -(p(i,j,k)-p(i-1,j,k))/dx12(i-1))/dx(i)
     &              +((p(i,j+1,k)-p(i,j,k))/dy12(j)
     &              -(p(i,j,k)-p(i,j-1,k))/dy12(j-1))/dy(j)
     &              +((p(i,j,k+1)-p(i,j,k))/dz12(k)
     &              -(p(i,j,k)-p(i,j,k-1))/dz12(k-1))/dz(k)
     &              -q(i,j,k)
     &              )/b0*1.6d0
               
            enddo
         enddo
      enddo
!$omp end do
!$omp end parallel      

!############################################################

!$omp parallel 
!$omp do schedule(STATIC) collapse(2)      
      do j=0,ny+1
         do i=0,nx+1
            p(i,j,0)=p(i,j,1)
            p(i,j,nz+1)=p(i,j,nz)
         enddo
      enddo
!$omp end do
!$omp end parallel
      
!$omp parallel 
!$omp do schedule(STATIC) collapse(2)      
      do k=0,nz+1
         do j=0,ny+1
            p(0,j,k)=p(1,j,k)
            p(nx+1,j,k)=p(nx,j,k)
         enddo
      enddo
!$omp end do
!$omp end parallel      

!$omp parallel 
!$omp do schedule(STATIC) collapse(2)      
      do k=0,nz+1
         do i=0,nx+1
            p(i,0,k)=p(i,1,k)
            p(i,ny+1,k)=p(i,ny,k)
         enddo
      enddo
!$omp end do
!$omp end parallel      
      
      p_st = p(1,1,1)

!$omp parallel 
!$omp do schedule(STATIC) collapse(2)      
      do k = 0,nz+1
         do j = 0,ny+1
            do i = 0,nx+1
               p(i,j,k) = p(i,j,k)-p_st
            end do
         end do
      end do
!$omp end do
!$omp end parallel      
      
      return
      end
!#################################################################
      subroutine linebyline
     &     (nx,ny,nz,u_temp,v_temp,w_temp,dx,dy,dz,dx12,dy12,dz12,
     &     dt,p)
      implicit double precision(a-h,o-z)
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision q(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      double precision x(0:nx+1),y(0:ny+1),z(0:nz+1)
      double precision x12(0:nx+1),y12(0:ny+1),z12(0:nz+1)
      double precision u_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision v_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision w_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision fpx(0:nx+1)
      double precision fpy(0:nx+1)
      double precision fpz(0:nx+1)      

      do k=1,nz
         do j=1,ny
            do i=1,nx
               q(i,j,k)=((u_temp(i,j,k)-u_temp(i-1,j,k))/dx(i)
     &              +(v_temp(i,j,k)-v_temp(i,j-1,k))/dy(j)
     &              +(w_temp(i,j,k)-w_temp(i,j,k-1))/dz(k)
     &              )/dt
            enddo
         enddo
      enddo

      do k=1,nz
         do j=1,ny
            do i=1,nx
               Bx1=1.0d0/dx12(i)/dx(i)
               Bx2=1.0d0/dx12(i-1)/dx(i)
               By1=1.0d0/dy12(j)/dy(j)
               By2=1.0d0/dy12(j-1)/dy(j)
               Bz1=1.0d0/dz12(k)/dz(k)
               Bz2=1.0d0/dz12(k-1)/dz(k)

               fpx(i)=-By1*p(i,j+1,k)-By2*p(i,j-1,k)
     &              -Bz1*p(i,j,k+1)-Bz2*p(i,j,k-1)
     &              +q(i,j,k)
            enddo
            ft=0.0d0
            fb=0.0d0
            call implicit_px
     &           (fpx,nx,Bx1,Bx2,By1,By2,Bz1,Bz2,ft,fb)
            do i=1,nx
               p(i,j,k)=fpx(i)
            enddo
         enddo
      enddo

      do k=1,nz
         do i=1,nx
            do j=1,ny
               Bx1=1.0d0/dx12(i)/dx(i)
               Bx2=1.0d0/dx12(i-1)/dx(i)
               By1=1.0d0/dy12(j)/dy(j)
               By2=1.0d0/dy12(j-1)/dy(j)
               Bz1=1.0d0/dz12(k)/dz(k)
               Bz2=1.0d0/dz12(k-1)/dz(k)

               fpy(j)=-Bx1*p(i+1,j,k)-Bx2*p(i-1,j,k)
     &              -Bz1*p(i,j,k+1)-Bz2*p(i,j,k-1)
     &              +q(i,j,k)
            enddo
            ft=0.0d0
            fb=0.0d0
            call implicit_py
     &           (fpy,ny,Bx1,Bx2,By1,By2,Bz1,Bz2,ft,fb)            
            do j=1,ny
               p(i,j,k)=fpy(j)
            enddo
         enddo
      enddo

      do j=1,ny
         do i=1,nx
            do k=1,nz
               Bx1=1.0d0/dx12(i)/dx(i)
               Bx2=1.0d0/dx12(i-1)/dx(i)
               By1=1.0d0/dy12(j)/dy(j)
               By2=1.0d0/dy12(j-1)/dy(j)
               Bz1=1.0d0/dz12(k)/dz(k)
               Bz2=1.0d0/dz12(k-1)/dz(k)
               
               fpz(k)=-Bx1*p(i+1,j,k)-Bx2*p(i-1,j,k)
     &              -By1*p(i,j+1,k)-By2*p(i,j-1,k)
     &              +q(i,j,k)
            enddo
            ft=0.0d0
            fb=0.0d0
            call implicit_pz
     &           (fpz,nz,Bx1,Bx2,By1,By2,Bz1,Bz2,ft,fb)            
            do k=1,nz
               p(i,j,k)=fpz(k)
            enddo
         enddo
      enddo

      do j=0,ny+1
         do i=0,nx+1
            p(i,j,0)=p(i,j,1)
            p(i,j,nz+1)=p(i,j,nz)
         enddo
      enddo

      do k=0,nz+1
         do j=0,ny+1
            p(0,j,k)=p(1,j,k)
            p(nx+1,j,k)=p(nx,j,k)
         enddo
      enddo

      do k=0,nz+1
         do i=0,nx+1
            p(i,0,k)=p(i,1,k)
            p(i,ny+1,k)=p(i,ny,k)
         enddo
      enddo

      p_st=p(1,1,1)

      do k=0,nz+1
         do j=0,ny+1
            do i=0,nx+1
               p(i,j,k)=p(i,j,k)-p_st
            enddo
         enddo
      enddo
      

      end

!#################################################################
      
      subroutine implicit_px
     &     (fpx,nx,Bx1,Bx2,By1,By2,Bz1,Bz2,ft,fb)
      implicit double precision(a-h,o-z)
      double precision a(0:nx+1,0:nx+1)
      double precision fpx(0:nx+1)
      double precision px(0:nx+1)
      
      do j=0,nx+1
         do i=0,nx+1
            a(i,j)=0.0d0
         enddo
      enddo

      a(0,0)=1.0d0
      a(0,1)=-1.0d0
      a(nx+1,nx+1)=1.0d0
      a(nx+1,nx)=-1.0d0

      do i=1,nx
         a(i,i-1)=Bx2
         a(i,i)=-(
     &        Bx1+Bx2+By1+By2+Bz1+Bz2
     &        )
         a(i,i+1)=Bx1
      enddo

      do i=1,nx
         px(i) = fpx(i)
      enddo

!     boundary condition

      px(0)=ft
      px(nx+1)=fb

      do i=nx+1,1,-1
         aa=a(i,i)
         a(i,i)=a(i,i)/aa       !equal 1.0d0
         a(i,i-1)=a(i,i-1)/aa
         bb=a(i-1,i)
         a(i-1,i)=a(i-1,i)-bb*a(i,i) !equal 0.0d0
         a(i-1,i-1)=a(i-1,i-1)-bb*a(i,i-1)

         px(i)=px(i)/aa
         px(i-1)=px(i-1)-bb*px(i)
      enddo
      
      do i=0,nx
         aa=a(i,i)
         a(i,i)=a(i,i)/aa       !equal 1.0d0
         bb=a(i+1,i)
         a(i+1,i)=a(i+1,i)-bb*a(i,i) !equal 0.0d0
         
         px(i)=px(i)/aa
         px(i+1)=px(i+1)-bb*px(i)
      enddo

      do i=1,nx
         fpx(i) = px(i)
      enddo

      end

      subroutine implicit_py
     &     (fpy,ny,Bx1,Bx2,By1,By2,Bz1,Bz2,ft,fb)
      implicit double precision(a-h,o-z)
      double precision a(0:ny+1,0:ny+1)
      double precision fpy(0:ny+1)
      double precision py(0:ny+1)
      
      do j=0,ny+1
         do i=0,ny+1
            a(i,j)=0.0d0
         enddo
      enddo

      a(0,0)=1.0d0
      a(0,1)=-1.0d0
      a(ny+1,ny+1)=1.0d0
      a(ny+1,ny)=-1.0d0

      do j=1,ny
         a(j,j-1)=By2
         a(j,j)=-(
     &        Bx1+Bx2+By1+By2+Bz1+Bz2
     &        )
         a(j,j+1)=By1
      enddo

      do j=1,ny
         py(j) = fpy(j)
      enddo

!     boundary condjtion

      py(0)=ft
      py(ny+1)=fb

      do j=ny+1,1,-1
         aa=a(j,j)
         a(j,j)=a(j,j)/aa       !equal 1.0d0
         a(j,j-1)=a(j,j-1)/aa
         bb=a(j-1,j)
         a(j-1,j)=a(j-1,j)-bb*a(j,j) !equal 0.0d0
         a(j-1,j-1)=a(j-1,j-1)-bb*a(j,j-1)

         py(j)=py(j)/aa
         py(j-1)=py(j-1)-bb*py(j)
      enddo
      
      do j=0,ny
         aa=a(j,j)
         a(j,j)=a(j,j)/aa       !equal 1.0d0
         bb=a(j+1,j)
         a(j+1,j)=a(j+1,j)-bb*a(j,j) !equal 0.0d0
         
         py(j)=py(j)/aa
         py(j+1)=py(j+1)-bb*py(j)
      enddo

      do j=1,ny
         fpy(j) = py(j)
      enddo

      end

      subroutine implicit_pz
     &     (fpz,nz,Bx1,Bx2,By1,By2,Bz1,Bz2,ft,fb)
      implicit double precision(a-h,o-z)
      double precision a(0:nz+1,0:nz+1)
      double precision fpz(0:nz+1)
      double precision pz(0:nz+1)
      
      do j=0,nz+1
         do i=0,nz+1
            a(i,j)=0.0d0
         enddo
      enddo

      a(0,0)=1.0d0
      a(0,1)=-1.0d0
      a(nz+1,nz+1)=1.0d0
      a(nz+1,nz)=-1.0d0

      do k=1,nz
         a(k,k-1)=Bz2
         a(k,k)=-(
     &        Bx1+Bx2+By1+By2+Bz1+Bz2
     &        )
         a(k,k+1)=Bz1
      enddo

      do k=1,nz
         pz(k) = fpz(k)
      enddo

!     boundary condjtion

      pz(0)=ft
      pz(nz+1)=fb

      do k=nz+1,1,-1
         aa=a(k,k)
         a(k,k)=a(k,k)/aa       !equal 1.0d0
         a(k,k-1)=a(k,k-1)/aa
         bb=a(k-1,k)
         a(k-1,k)=a(k-1,k)-bb*a(k,k) !equal 0.0d0
         a(k-1,k-1)=a(k-1,k-1)-bb*a(k,k-1)

         pz(k)=pz(k)/aa
         pz(k-1)=pz(k-1)-bb*pz(k)
      enddo
      
      do k=0,nz
         aa=a(k,k)
         a(k,k)=a(k,k)/aa       !equal 1.0d0
         bb=a(k+1,k)
         a(k+1,k)=a(k+1,k)-bb*a(k,k) !equal 0.0d0
         
         pz(k)=pz(k)/aa
         pz(k+1)=pz(k+1)-bb*pz(k)
      enddo

      do k=1,nz
         fpz(k) = pz(k)
      enddo

      end
      
!#################################################################
c     update velocity
      subroutine solve_u_next
     &     (u,v,w,u_temp,v_temp,w_temp,p,dt,dx12,dy12,dz12,nx,ny,nz,
     &     u_ta,v_ta,w_ta,u_ep2,v_ep2,w_ep2,divu,dx,dy,dz)
      implicit double precision(a-h,o-z)
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision u_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision v_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision w_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision u_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)
      double precision divu(0:nx+1,0:ny+1,0:nz+1)

      double precision u_ep2(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ep2(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ep2(0:nx+1,0:ny+1,0:nz+1)

      do k = 1,nz
         do j = 1,ny
            do i = 1,nx
               uu = -dt*(p(i+1,j,k)-p(i,j,k))/dx12(i)
               vv = -dt*(p(i,j+1,k)-p(i,j,k))/dy12(j)
               ww = -dt*(p(i,j,k+1)-p(i,j,k))/dz12(k)

               u(i,j,k) = u_temp(i,j,k)+uu
               v(i,j,k) = v_temp(i,j,k)+vv
               w(i,j,k) = w_temp(i,j,k)+ww

               u_ep2(i,j,k)=uu+u_ta(i,j,k)
               v_ep2(i,j,k)=vv+v_ta(i,j,k)
               w_ep2(i,j,k)=ww+w_ta(i,j,k)

               u_ta(i,j,k) = -uu
               v_ta(i,j,k) = -vv
               w_ta(i,j,k) = -ww
            end do
         end do
      end do

      do k=1,nz
         do j=1,ny
            do i=1,nx
               divu(i,j,k)=(u(i,j,k)-u(i-1,j,k))/dx(i)
     &              +(v(i,j,k)-v(i,j-1,k))/dy(j)
     &              +(w(i,j,k)-w(i,j,k-1))/dz(k)
            enddo
         enddo
      enddo

      return
      end

!####################################################################
      subroutine check_courant(dt,dx,dy,dz,nx,ny,nz,u,v,w)
      implicit double precision(a-h,o-z)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision courant_x(1:nx,1:ny,1:nz)
      double precision courant_y(1:nx,1:ny,1:nz)
      double precision courant_z(1:nx,1:ny,1:nz)
      double precision courant

      c=1.0d0
      courant_x=0.0d0
      courant_y=0.0d0
      courant_z=0.0d0
      courant_max_x=0.0d0
      courant_max_y=0.0d0
      courant_max_z=0.0d0
      courant_max=0.0d0
      courant=0.0d0 
!$omp parallel do private(i,j,k)     
      do k=1,nz
         do j=1,ny
            do i=1,nx
               courant_x(i,j,k)=u(i,j,k)*dt/dx(i)
            enddo
         enddo
      enddo
!$omp end parallel do
!$omp parallel do private(i,j,k)
      do k=1,nz
         do i=1,nx
            do j=1,ny
               courant_y(i,j,k)=v(i,j,k)*dt/dy(j)
            enddo
         enddo
      enddo
!$omp end parallel do
!$omp parallel do private(i,j,k)
      do k=1,nz
         do j=1,ny
            do i=1,nx
               courant_z(i,j,k)=w(i,j,k)*dt/dz(k)
            enddo
         enddo
      enddo
!$omp end parallel do
      courant_max_x=0.0d0
      do k=1,nz
         do j=1,ny
            do i=1,nx
               if(courant_max_x<courant_x(i,j,k))then
                  courant_max_x=courant_x(i,j,k)
               endif
            enddo
         enddo
      enddo
      courant_max_y=0.0d0
      do k=1,nz
         do j=1,ny
            do i=1,nx
               if(courant_max_y<courant_y(i,j,k))then
                  courant_max_y=courant_y(i,j,k)
               endif
            enddo
         enddo
      enddo
      courant_max_z=0.0d0
      do k=1,nz
         do j=1,ny
            do i=1,nx
               if(courant_max_z<courant_z(i,j,k))then
                  courant_max_z=courant_z(i,j,k)
               endif
            enddo
         enddo
      enddo
      courant=max(courant_max_x,courant_max_y,courant_max_z)

      write(6,*)'courant max =',courant
      
      end subroutine


!---------------------------------------------------------------------------

c     write instantanous crossection data
      subroutine output
     &     (u,v,w,p,x,y,z,x12,y12,z12,nx,ny,nz,T,cellvalue,
     &     u_ta,v_ta,w_ta,u_temp,v_temp,w_temp,eta,T_before,
     &     dx,dy,dz,dx12,dy12,dz12,phi,u_vpm,v_vpm,w_vpm,divu,
     &     rad)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision u_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision u_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision v_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision w_temp(0:nx+1,0:ny+1,0:nz+1)
      double precision u_vpm(0:nx+1,0:ny+1,0:nz+1)
      double precision v_vpm(0:nx+1,0:ny+1,0:nz+1)
      double precision w_vpm(0:nx+1,0:ny+1,0:nz+1)      
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dx12(0:nx+1),dy12(0:ny+1),dz12(0:nz+1)      
      double precision x(0:nx+1),y(0:ny+1),z(0:nz+1)
      double precision x12(0:nx+1),y12(0:ny+1),z12(0:nz+1)
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      double precision T_before(0:nx+1,0:ny+1,0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision phi(0:nx+1,0:ny+1,0:nz+1)      
      double precision divu(0:nx+1,0:ny+1,0:nz+1)
      double precision rad(0:nx+1,0:ny+1,0:nz+1)            
      call system(
     &'if [ ! -d nseoutput2 ]; then 
     &   (echo "Create nseoutput2 directory"; mkdir -p nseoutput2); 
     & fi')
      open(1000,file='./nseoutput2/velocity.dat',form='unformatted')
      open(1001,file='./nseoutput2/temperature.dat',form='unformatted')
      open(1002,file='./nseoutput2/pressure.dat',form='unformatted')
      open(1003,file='./nseoutput2/divergence.dat',form='unformatted')
      open(1004,file='./nseoutput2/gridx.dat',form='unformatted')
      open(1005,file='./nseoutput2/gridy.dat',form='unformatted')
      open(1006,file='./nseoutput2/gridz.dat',form='unformatted')
      open(1007,file='./nseoutput2/gridnumber.dat',form='unformatted')
      open(1008,file='./nseoutput2/phi.dat',form='unformatted')
      open(1009,file='./nseoutput2/divergenceProfileU.dat')
      open(1010,file='./nseoutput2/divergenceProfileV.dat')
      open(1011,file='./nseoutput2/divergenceProfileW.dat')
      do k=1,nz
         do j=1,ny
            do i=1,nx
               ua=(u(i-1,j,k)+u(i,j,k))*0.50d0
               va=(v(i,j-1,k)+v(i,j,k))*0.50d0
               wa=(w(i,j,k-1)+w(i,j,k))*0.50d0                       
               divu(i,j,k)=(u(i,j,k)-u(i-1,j,k))/dx(i)
     &              +(v(i,j,k)-v(i,j-1,k))/dy(j)
     &              +(w(i,j,k)-w(i,j,k-1))/dz(k)
               if(k.eq.32)then
                    if(i.eq.32)then
                 write(1009,*)u(i,j,k),u(i-1,j,k),dx(i)
                 write(1010,*)v(i,j,k),v(i,j-1,k),dy(j)
                 write(1011,*)w(i,j,k),w(i,j,k-1),dz(k)
                    endif
               endif
               if(dabs(ua).lt.1.0d-030)then
                  ua=0.0d0
               endif
               
               if(dabs(va).lt.1.0d-030)then
                  va=0.0d0
               endif
               
               if(dabs(wa).lt.1.0d-030)then
                  wa=0.0d0
               endif
               write(1000)ua,va,wa
               write(1002)p(i,j,k)
               write(1001)T(i,j,k)
               write(1003)divu(i,j,k)
               write(1008)phi(i,j,k)
            enddo
         enddo
      enddo
      close(1009)
      close(1010)
      close(1011)      
      open(1100,file='temperature_check.dat')
      i=nx
      k=nz/2
      do j=0,ny+1
         write(1100,*)y(j),T(i,j,k)
      enddo
      close(1100)
      do i=1,nx
         write(1004)x(i)
      enddo
      do j=1,ny
         write(1005)y(j)
      enddo
      do k=1,nz
         write(1006)z(k)
      enddo
      write(1007) nx,ny,nz
      close(1000)
      close(1001)
      close(1002)
      close(1003)
      close(1004)
      close(1005)
      close(1006)
      close(1007)
      open(100,file='./nseoutput2/field.u',form='unformatted')
      write(100)tid
      do k=0,nz+1
         do j=0,ny+1
            do i=0,nx+1
               write(100)u(i,j,k),v(i,j,k),w(i,j,k),p(i,j,k),T(i,j,k)
     &              ,phi(i,j,k),u_ta(i,j,k),v_ta(i,j,k),w_ta(i,j,k)
            enddo
         enddo
      enddo
      close(100)

      open(101,file='./nseoutput2/grid.u',form='unformatted')
      write(101)tid
      do i=1,nx
         write(101)x(i)
      enddo
      do j=1,ny
         write(101)y(j)
      enddo
      do k=1,nz
         write(101)z(k)
      enddo
      close(101)

      open(200,file='./nseoutput2/VelocityX_Profile.csv')
      do j=0,ny+1
      write(200,*)j,',',y(j),',',u(32,j,32)
      enddo
      close(200)

      return
      end

c     write field data   
      subroutine outfield(x,y,z,u,v,w,p,nx,ny,nz,tid,T,phi,
     &     u_ta,v_ta,w_ta)
      implicit double precision(a-h,o-z)
      double precision x(0:nx+1),y(0:ny+1),z(0:nz+1)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision tid
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      double precision phi(0:nx+1,0:ny+1,0:nz+1)
      double precision u_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ta(0:nx+1,0:ny+1,0:nz+1)

      open(100,file='field.u',form='unformatted')
      write(100)tid
      do k=0,nz+1
         do j=0,ny+1
            do i=0,nx+1
               write(100)u(i,j,k),v(i,j,k),w(i,j,k),p(i,j,k),T(i,j,k)
     &              ,phi(i,j,k),u_ta(i,j,k),v_ta(i,j,k),w_ta(i,j,k)
            enddo
         enddo
      enddo
      close(100)

      open(101,file='grid.u',form='unformatted')
      write(101)tid
      do i=1,nx
         write(101)x(i)
      enddo
      do j=1,ny
         write(101)y(j)
      enddo
      do k=1,nz
         write(101)z(k)
      enddo
      close(101)
      
      return
      end

c     read field data      
      subroutine readfield(u,v,w,p,nx,ny,nz,tid,T,phi,
     &     u_ta,v_ta,w_ta)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision p(0:nx+1,0:ny+1,0:nz+1)
      double precision tid
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      double precision phi(0:nx+1,0:ny+1,0:nz+1)
      double precision u_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision v_ta(0:nx+1,0:ny+1,0:nz+1)
      double precision w_ta(0:nx+1,0:ny+1,0:nz+1)
      
      open(100,file='field.u',form='unformatted')
      read(100)tid
      do k=0,nz+1
         do j=0,ny+1
            do i=0,nx+1
               read(100)u(i,j,k),v(i,j,k),w(i,j,k),p(i,j,k),T(i,j,k)
     &              ,phi(i,j,k),u_ta(i,j,k),v_ta(i,j,k),w_ta(i,j,k)
            enddo
         enddo
      enddo
      
      close(100)
      return
      end

!------------------------------------------------------------------
      
      subroutine monitor(nx,ny,nz,l,T,dx,dy,dz,dif,T_all,T_dif,T_before,
     &     u,v,w,vel_dif,u_dif,v_dif,w_dif,
     &     u_int_before,v_int_before,w_int_before,T_b,dt,int_report)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision v(0:nx+1,0:ny+1,0:nz+1)
      double precision w(0:nx+1,0:ny+1,0:nz+1)
      double precision T(0:nx+1,0:ny+1,0:nz+1)
      double precision T_before(0:nx+1,0:ny+1,0:nz+1)
      double precision dx(0:nx+1),dy(0:ny+1),dz(0:nz+1)
      double precision dif,T_all,T_b,T_each,T_dif

      if(l==1)then
         T_b=0.0d0
         u_int_before=0.0d0
         v_int_before=0.0d0
         w_int_before=0.0d0
      endif

      u_int=0.0d0
      v_int=0.0d0
      w_int=0.0d0
      do k=1,nz
         do j=1,ny
            do i=1,nx
               u_int=u_int+dabs(u(i,j,k))*dx(i)
               v_int=v_int+dabs(v(i,j,k))*dy(j)
               w_int=w_int+dabs(w(i,j,k))*dz(k)
            enddo
         enddo
      enddo

      u_dif=dabs((u_int-u_int_before)/u_int)
      v_dif=dabs((v_int-v_int_before)/v_int)
      w_dif=dabs((w_int-w_int_before)/w_int)

!     vel_dif=dmax1(u_dif,v_dif,w_dif)
      vel_dif=dmax1(u_dif,v_dif)

      u_int_before=u_int
      v_int_before=v_int
      w_int_before=w_int

      T_all=0.0d0
      do j=1,ny
         do i=1,nx
            T_all=T_all+T(i,j,k)*dx(i)*dy(j)*dz(k)
         enddo
      enddo
      if(int_report .eq. 1)then
         write(*,*)T_all,T_b      
         write(*,*)"T_all =",T_all
         write(*,*)"time error of C is:",(T_all-T_b)/dt
      endif
      dif=dabs((T_all-T_b)/T_all)
      T_b=T_all
      T_dif=0.0d0
      T_each=0.0d0
      do k=1,nz
         do j=1,ny
            do i=1,nx
               T_each=abs(T(i,j,k)-T_before(i,j,k))
               if(T_each>T_dif)then
                  T_dif=T_each
                  xx=i
                  yy=j
                  zz=k
               endif
            enddo
         enddo
      enddo
      if(int_report .eq. 1)then
         write(*,*)xx,yy,zz
      endif
      return
      end

!-----------validation of channel laminar flow----------------------------------------------------
      subroutine check_convergence(y,yl,u,l,dt,Re,nx,ny,nz)
      implicit double precision(a-h,o-z)
      double precision u(0:nx+1,0:ny+1,0:nz+1)
      double precision y(0:ny+1)
      error_sum=0.0d0
      i=nx
      do k=1,nz
         do j=1,ny
            analytic_solution=-Re/2*y(j)*(y(j)-yl)
            error_sum=error_sum+dabs(u(i,j,k)-analytic_solution)
         enddo
      enddo
      open(100,file='timely_convergence.dat',form='formatted',
     & position='APPEND')
      write(100,*)l*dt,error_sum
      close(100)
      END
!----------subroutine for parallel computing------------------------------------
      subroutine parallel_uy(i,k,u_a,cellvalue,nx,ny,nz,dy,dy12,Re,
     & dt,eta,n)
      implicit double precision(a-h,o-z)
      double precision u_a(0:nx+1,0:ny+1,0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision SUY(0:ny+1),CUY(1:ny)
      double precision dy(0:ny+1),dy12(0:ny+1)
      do j = 1,ny
         SUY(j) = u_a(i,j,k)
         CUY(j) = cellvalue(i,j,k,n)               
      end do
      ft=0.0d0
      fb=0.0d0
      call implicit_uy(SUY,ny,dy,dy12,Re,dt,ft,fb,eta,CUY)
      do j = 0,ny+1
         u_a(i,j,k) = SUY(j)
      end do
      end
!------------------------------------------------------------------------            
      subroutine parallel_z(i,j,u_a,cellvalue,nx,ny,nz,dz,dz12,Re,
     & dt,eta)
      implicit double precision(a-h,o-z)
      double precision u_a(0:nx+1,0:ny+1,0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision SUZ(0:nz+1),CUZ(1:nz)
      double precision dz(0:nz+1),dz12(0:nz+1)
      do k = 0,nz+1
         SUZ(k) = u_a(i,j,k)
         CUZ(k) = cellvalue(i,j,k,n)               
      end do
      ft=0.0d0
      fb=0.0d0
      call implicit_solver(SUZ,nz,dz,dz12,Re,dt,ft,fb,eta,CUZ)
      do k = 0,nz+1
         u_a(i,j,k) = SUZ(k)
      end do 
      end
!--------------------------------------------------------------------
      subroutine parallel_x(j,k,u_a,cellvalue,nx,ny,nz,dx,dx12,Re,
     & dt,eta,n)
      implicit double precision(a-h,o-z)
      double precision u_a(0:nx+1,0:ny+1,0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision SUX(0:nx+1),CUX(1:nx)
      double precision dx(0:nx+1),dx12(0:nx+1)
      do i = 0,nx+1
         SUX(i) = u_a(i,j,k)
         CUX(i) = cellvalue(i,j,k,n)
      end do
      ft=0.0d0
      fb=0.0d0
      call implicit_solver(SUX,nx,dx,dx12,Re,dt,ft,fb,eta,CUX)
      do i = 0,nx+1
         u_a(i,j,k) = SUX(i)
      end do
      end
!------------------------------------------------------------------
      subroutine parallel_vy(i,k,v_a,cellvalue,nx,ny,nz,dy,dy12,Re,
     &       dt,eta,n)
      implicit double precision(a-h,o-z)
      double precision v_a(0:nx+1,0:ny+1,0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision SVY(0:ny+1),CVY(1:ny)
      double precision dy(0:ny+1),dy12(0:ny+1)      
      do j = 1,ny-1
         SVY(j) = v_a(i,j,k)
         CVY(j) = cellvalue(i,j,k,n)                              
      end do
      ft=0.0d0
      fb=0.0d0
      call implicit_vy(SVY,ny,dy,dy12,Re,dt,ft,fb,eta,CVY)
      do j = 0,ny
         v_a(i,j,k) = SVY(j)
      end do
      end
!---------------------------------------------------------------
      subroutine parallel_Tx(k,j,nx,ny,nz,rhoCp,thc,u_T,cellvalue,dx,
     &     dx12,Re,Sc,dt,eta)
      implicit double precision(a-h,o-z)
      double precision u_T(0:nx+1,0:ny+1,0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision rhoCp(0:nx+1,0:ny+1,0:nz+1)
      double precision thc(0:nx+1,0:ny+1,0:nz+1)
      double precision STX(0:nx+1),CUX(0:nx+1)
      double precision rrx(0:nx+1),llx(0:nx+1)
      double precision dx(0:nx+1),dx12(0:nx+1)      
      do i=0,nx+1
         rrx(i)=rhoCp(i,j,k)
         llx(i)=thc(i,j,k)
         STX(i)=u_T(i,j,k)
         CUx(i)=cellvalue(i,j,k,1)
      enddo
!ft=f(0,j,k)
!fb=0.0d0
      ft=0.0d0
      fb=0.0d0
      call implicit_Tx
     &     (STX,nx,dx,dx12,Re,Sc,dt,llx,rrx,ft,fb,
     &     eta,CUX)
      do i=1,nx
         u_T(i,j,k)=STX(i)
      enddo
      end
!--------------------------------------------------------------
      subroutine parallel_Ty(i,k,nx,ny,nz,rhoCp,thc,u_T,cellvalue,dy,
     &     dy12,Re,Sc,dt,eta)
      implicit double precision(a-h,o-z)
      double precision u_T(0:nx+1,0:ny+1,0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision rhoCp(0:nx+1,0:ny+1,0:nz+1)
      double precision thc(0:nx+1,0:ny+1,0:nz+1)
      double precision STY(0:ny+1),CUY(0:ny+1)
      double precision rry(0:nx+1),lly(0:ny+1)
      double precision dy(0:ny+1),dy12(0:ny+1)      
      do j=0,ny+1
         rry(j)=rhoCp(i,j,k)
         lly(j)=thc(i,j,k)
         STY(j)=u_T(i,j,k)
         CUY(j)=cellvalue(i,j,k,1)
      enddo
      ft=0.0d0
      fb=0.0d0
      call implicit_Ty
     &     (STY,ny,dy,dy12,Re,Sc,dt,lly,rry,ft,fb
     &     ,CUY,eta)
      do j=1,ny
         u_T(i,j,k)=STY(j)
      enddo
      end
!------------------------------------------------------------
      subroutine parallel_Tz(i,j,nx,ny,nz,rhoCp,thc,u_T,cellvalue,dz,
     &     dz12,Re,Sc,dt,eta)
      implicit double precision(a-h,o-z)
      double precision u_T(0:nx+1,0:ny+1,0:nz+1)
      double precision cellvalue(1:nx,1:ny,1:nz,1:4)
      double precision rhoCp(0:nx+1,0:ny+1,0:nz+1)
      double precision thc(0:nx+1,0:ny+1,0:nz+1)
      double precision STZ(0:nz+1),CUZ(0:nz+1)
      double precision rrz(0:nz+1),llz(0:nz+1)
      double precision dz(0:nz+1),dz12(0:nz+1)      
      do k=0,nz+1
         rrz(k)=rhoCp(i,j,k)
         llz(k)=thc(i,j,k)
         STZ(k)=u_T(i,j,k)
         CUZ(k)=cellvalue(i,j,k,1)
      enddo
      ft=0.0d0
      fb=0.0d0
      call implicit_Tx
     &     (STZ,nz,dz,dz12,Re,Sc,dt,llz,rrz,ft,fb,
     &     eta,CUZ)
      do k=1,nz
         u_T(i,j,k)=STZ(k)
      enddo
      end
